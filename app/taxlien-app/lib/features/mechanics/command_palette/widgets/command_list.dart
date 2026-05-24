import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/palette_command.dart';
import 'command_item.dart';

/// A scrollable list of commands with keyboard navigation.
class CommandList extends StatefulWidget {
  const CommandList({
    super.key,
    required this.commands,
    required this.selectedIndex,
    this.onSelect,
    this.onExecute,
    this.groupByCategory = true,
    this.maxHeight = 400,
  });

  final List<PaletteCommand> commands;
  final int selectedIndex;
  final ValueChanged<int>? onSelect;
  final ValueChanged<PaletteCommand>? onExecute;
  final bool groupByCategory;
  final double maxHeight;

  @override
  State<CommandList> createState() => _CommandListState();
}

class _CommandListState extends State<CommandList> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void didUpdateWidget(CommandList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _ensureSelectedVisible();
    }
  }

  void _ensureSelectedVisible() {
    if (widget.commands.isEmpty) return;

    const itemHeight = 60.0;
    final targetOffset = widget.selectedIndex * itemHeight;
    final viewportHeight = _scrollController.position.viewportDimension;
    final currentOffset = _scrollController.offset;

    if (targetOffset < currentOffset) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    } else if (targetOffset + itemHeight > currentOffset + viewportHeight) {
      _scrollController.animateTo(
        targetOffset + itemHeight - viewportHeight,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final newIndex = (widget.selectedIndex + 1) % widget.commands.length;
      widget.onSelect?.call(newIndex);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final newIndex = widget.selectedIndex - 1;
      widget.onSelect?.call(
        newIndex < 0 ? widget.commands.length - 1 : newIndex,
      );
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (widget.selectedIndex < widget.commands.length) {
        widget.onExecute?.call(widget.commands[widget.selectedIndex]);
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.commands.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No commands found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    Widget content;

    if (widget.groupByCategory) {
      // Group commands by category
      final grouped = <CommandCategory, List<PaletteCommand>>{};
      for (final command in widget.commands) {
        grouped.putIfAbsent(command.category, () => []).add(command);
      }

      var globalIndex = 0;
      content = ListView(
        controller: _scrollController,
        shrinkWrap: true,
        children: [
          for (final entry in grouped.entries) ...[
            // Category header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                entry.key.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Commands in category
            for (final command in entry.value)
              Builder(builder: (context) {
                final index = globalIndex++;
                return CommandItem(
                  command: command,
                  isSelected: index == widget.selectedIndex,
                  onTap: () => widget.onExecute?.call(command),
                );
              }),
          ],
        ],
      );
    } else {
      content = ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: widget.commands.length,
        itemBuilder: (context, index) {
          return CommandItem(
            command: widget.commands[index],
            isSelected: index == widget.selectedIndex,
            onTap: () => widget.onExecute?.call(widget.commands[index]),
          );
        },
      );
    }

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        child: content,
      ),
    );
  }
}
