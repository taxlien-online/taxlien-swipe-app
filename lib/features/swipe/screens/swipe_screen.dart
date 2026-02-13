import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';
import '../../tutorial/services/tutorial_service.dart';
import '../../tutorial/widgets/nudge_banner.dart';
import '../providers/swipe_provider.dart';
import '../widgets/property_card_beginner.dart';
import '../widgets/advanced_swipe_stack.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/offline_empty_state.dart';
import '../../../core/models/expert_role.dart';
import '../../../core/models/property_card_data.dart';
import '../../../core/models/swipe_mode.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  String? _nudgeId;
  bool _nudgeCheckScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SwipeProvider>().loadProperties();
    });
  }

  void _scheduleNudgeCheck(SwipeProvider provider) {
    if (_nudgeCheckScheduled) return;
    _nudgeCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tutorial = context.read<TutorialService>();
      final stats = await tutorial.getStats();
      if (!mounted) return;
      final id = await tutorial.getNextNudge(
        stats,
        isBeginnerMode: provider.swipeMode == SwipeMode.beginner,
      );
      if (mounted) setState(() => _nudgeId = id);
    });
  }

  Future<void> _onNudgeTry(String nudgeId, SwipeProvider? provider) async {
    final tutorial = context.read<TutorialService>();
    await tutorial.markNudgeShown(nudgeId);
    if (!mounted) return;
    setState(() => _nudgeId = null);
    if (nudgeId == 'expert_mode' && provider != null) {
      provider.setSwipeMode(SwipeMode.advanced);
    } else if (nudgeId == 'foreclosure_filter') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => const FilterSheet(),
      );
    } else if (nudgeId == 'family_board') {
      context.push('/family');
    }
  }

  Future<void> _onNudgeDismiss(String nudgeId) async {
    final tutorial = context.read<TutorialService>();
    await tutorial.markNudgeShown(nudgeId);
    if (mounted) setState(() => _nudgeId = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dealDetective),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _onFilterPressed(context),
          ),
          _buildSwipeModeSwitcher(),
          _buildRolePicker(),
        ],
      ),
      body: Consumer<SwipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.properties.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.properties.isEmpty) {
            return const OfflineEmptyState();
          }

          _scheduleNudgeCheck(provider);

          Widget content;
          if (provider.swipeMode == SwipeMode.beginner) {
            content = _buildBeginnerModeStack(provider);
          } else {
            final cardData = provider.properties
                .map((l) => PropertyCardData.fromTaxLien(l))
                .toList();
            content = AdvancedSwipeStack(
              properties: cardData,
              currentIndex: provider.currentIndex,
              onLike: (id) => provider.handleLike(id),
              onPass: (id) => provider.handlePass(id),
              onPageChanged: (index) => provider.setCurrentIndex(index),
            );
          }

          if (_nudgeId == null) return content;
          return Stack(
            children: [
              content,
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: NudgeBanner(
                  nudgeId: _nudgeId!,
                  onTry: () => _onNudgeTry(_nudgeId!, provider),
                  onDismiss: () => _onNudgeDismiss(_nudgeId!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onFilterPressed(BuildContext context) async {
    final tutorial = context.read<TutorialService>();
    final showHint = await tutorial.shouldShowHint('filter_button');
    if (!context.mounted) return;
    if (showHint) {
      final l10n = AppLocalizations.of(context)!;
      final dontShowAgain = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Theme.of(ctx).colorScheme.primary),
              const SizedBox(width: 8),
              Text(l10n.hintFilterTitle),
            ],
          ),
          content: Text(l10n.hintFilterBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.hintDontShowAgain),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.hintGotIt),
            ),
          ],
        ),
      );
      await tutorial.markHintShown('filter_button', dontShowAgain: dontShowAgain == true);
      if (!context.mounted) return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterSheet(),
    );
  }

  Widget _buildBeginnerModeStack(SwipeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // Display two cards for stack effect
          if (provider.currentIndex + 1 < provider.properties.length)
            Opacity(
              opacity: 0.5,
              child: Transform.scale(
                scale: 0.95,
                child: PropertyCardBeginner(
                  property: provider.properties[provider.currentIndex + 1],
                  onLike: () {},
                  onPass: () {},
                ),
              ),
            ),
          
          // Top Draggable Card
          Draggable(
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.height - 200, // Adjust height if needed
                child: PropertyCardBeginner(
                  property: provider.currentProperty!,
                  onLike: () {},
                  onPass: () {},
                ),
              ),
            ),
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: (details) {
              // Simple swipe logic
              if (details.offset.dx > 100) {
                provider.handleLike(provider.currentProperty!.id);
              } else if (details.offset.dx < -100) {
                provider.handlePass(provider.currentProperty!.id);
              } else {
                // If not swiped far enough, reset position (not implemented here for simplicity)
              }
            },
            child: PropertyCardBeginner(
              property: provider.currentProperty!,
              onLike: () => provider.handleLike(provider.currentProperty!.id),
              onPass: () => provider.handlePass(provider.currentProperty!.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolePicker() {
    return Consumer<SwipeProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<ExpertRole>(
          icon: Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
          onSelected: (role) => provider.setRole(role),
          itemBuilder: (context) => ExpertRole.values.map((role) {
            return PopupMenuItem(
              value: role,
              child: Text(role.name.toUpperCase()),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSwipeModeSwitcher() {
    return Consumer<SwipeProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<SwipeMode>(
          icon: Icon(
            provider.swipeMode == SwipeMode.beginner ? Icons.flash_on : Icons.settings,
            color: Theme.of(context).primaryColor,
          ),
          onSelected: (mode) => provider.setSwipeMode(mode),
          itemBuilder: (context) => SwipeMode.values.map((mode) {
            return PopupMenuItem(
              value: mode,
              child: Text(mode.name.toUpperCase()),
            );
          }).toList(),
        );
      },
    );
  }
}
