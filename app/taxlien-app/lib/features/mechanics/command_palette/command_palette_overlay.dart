import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gestures/three_finger.dart';
import 'models/palette_command.dart';
import 'widgets/command_input.dart';
import 'widgets/command_list.dart';

/// An overlay widget that provides a command palette.
class CommandPaletteOverlay extends StatefulWidget {
  const CommandPaletteOverlay({
    super.key,
    required this.child,
    this.onCommand,
    this.enabled = true,
  });

  final Widget child;
  final void Function(PaletteCommand command)? onCommand;
  final bool enabled;

  @override
  State<CommandPaletteOverlay> createState() => _CommandPaletteOverlayState();
}

class _CommandPaletteOverlayState extends State<CommandPaletteOverlay>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  int _selectedIndex = 0;
  List<PaletteCommand> _filteredCommands = DefaultCommands.all;

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _slideAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCommands = DefaultCommands.search(_searchController.text);
      _selectedIndex = 0;
    });
  }

  void _open() {
    setState(() {
      _isOpen = true;
      _searchController.clear();
      _filteredCommands = DefaultCommands.all;
      _selectedIndex = 0;
    });
    _animationController.forward();
    _focusNode.requestFocus();
  }

  void _close() {
    _animationController.reverse().then((_) {
      setState(() {
        _isOpen = false;
      });
    });
  }

  void _executeCommand(PaletteCommand command) {
    _close();
    widget.onCommand?.call(command);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _filteredCommands.length;
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = _selectedIndex > 0
            ? _selectedIndex - 1
            : _filteredCommands.length - 1;
      });
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex < _filteredCommands.length) {
        _executeCommand(_filteredCommands[_selectedIndex]);
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        // Child with three-finger gesture
        ThreeFingerGestureDetector(
          onThreeFingerPullDown: _open,
          child: Focus(
            onKeyEvent: (node, event) {
              // Cmd/Ctrl + K to open
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.keyK &&
                  (HardwareKeyboard.instance.isMetaPressed ||
                      HardwareKeyboard.instance.isControlPressed)) {
                _open();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: widget.child,
          ),
        ),

        // Palette overlay
        if (_isOpen) ...[
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Container(
                    color: Colors.black.withValues(alpha: 0.4 * _fadeAnimation.value),
                  );
                },
              ),
            ),
          ),

          // Palette
          Positioned(
            left: 40,
            right: 40,
            top: 80,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Focus(
                focusNode: _focusNode,
                onKeyEvent: _handleKeyEvent,
                child: Material(
                  elevation: 24,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommandInput(
                        controller: _searchController,
                        onSubmitted: (_) {
                          if (_selectedIndex < _filteredCommands.length) {
                            _executeCommand(_filteredCommands[_selectedIndex]);
                          }
                        },
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: CommandList(
                          commands: _filteredCommands,
                          selectedIndex: _selectedIndex,
                          onSelect: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          onExecute: _executeCommand,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Wrapper for easy integration - use at app scaffold level.
class CommandPaletteShortcuts extends StatelessWidget {
  const CommandPaletteShortcuts({
    super.key,
    required this.child,
    required this.onCommand,
  });

  final Widget child;
  final void Function(PaletteCommand command) onCommand;

  @override
  Widget build(BuildContext context) {
    return CommandPaletteOverlay(
      onCommand: onCommand,
      child: child,
    );
  }
}
