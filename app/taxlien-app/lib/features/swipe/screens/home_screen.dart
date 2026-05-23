import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../services/tax_lien_service.dart';
import '../../profile/services/expert_profile_service.dart';
import '../../profile/models/expert_profile.dart';
import '../../family/services/family_board_service.dart';
import '../widgets/swipeable_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/match_modal.dart';
import '../widgets/share_sheet.dart';
import '../widgets/tutorial.dart';
import '../../deeplink/widgets/smart_banner.dart';
import 'preferences_screen.dart';
import '../constants/swipe_constants.dart';
import '../services/match_service.dart';
import '../services/daily_limit_service.dart';
import '../models/user_preferences.dart';

/// Swipe Home Screen
///
/// Tinder-style swipe interface for property discovery
class SwipeHomeScreen extends StatefulWidget {
  final String? userId;
  final bool isPremium;

  const SwipeHomeScreen({
    super.key,
    this.userId,
    this.isPremium = false,
  });

  @override
  State<SwipeHomeScreen> createState() => _SwipeHomeScreenState();
}

class _SwipeHomeScreenState extends State<SwipeHomeScreen> {
  final List<TaxLien> _cardStack = [];
  final List<TaxLien> _swipeHistory = [];
  int _currentIndex = 0;
  int _swipeCount = 0;
  bool _isLoading = true;
  String? _error;
  UserPreferences _preferences = UserPreferences.defaults;
  bool _foreclosureFilterMode = false; // Foreclosure filter for Miw (sdd-miw-gift)

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadProperties();
    _showTutorialIfNeeded();
  }

  Future<void> _loadPreferences() async {
    // Load user preferences from storage
    // For now, using defaults
    setState(() {
      _preferences = UserPreferences.defaults;
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      await SwipeTutorial.showIfNeeded(context);
    }
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final taxLienService = TaxLienService();
      final List<TaxLien> properties;
      
      if (_foreclosureFilterMode) {
        // Load foreclosure candidates (sdd-miw-gift integration)
        properties = await taxLienService.searchForeclosureCandidates(
          state: 'AZ',
          priorYearsMin: 2,
          maxAmount: 500,
          foreclosureProbMin: 0.7,
        );
      } else {
        // Regular search
        properties = await taxLienService.searchLiens();
      }

      setState(() {
        _cardStack.clear();
        _cardStack.addAll(properties);
        _currentIndex = 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = SwipeConstants.errorNetworkFailure;
        _isLoading = false;
      });
    }
  }

  void _toggleForeclosureFilter() {
    setState(() {
      _foreclosureFilterMode = !_foreclosureFilterMode;
    });
    _loadProperties(); // Reload with new filter
  }

  Future<void> _loadMoreProperties() async {
    // Load next batch when running low
    if (_cardStack.length - _currentIndex < 3) {
      try {
        final taxLienService = TaxLienService();
        final moreProperties = await taxLienService.searchLiens();
        setState(() {
          _cardStack.addAll(moreProperties);
        });
      } catch (e) {
        // Silently fail for prefetch
        debugPrint('Failed to load more properties: $e');
      }
    }
  }

  void _handleSwipeLeft() {
    final profileService = Provider.of<ExpertProfileService>(context, listen: false);
    if (profileService.isAnton) {
      _showContextOverlay();
    } else {
      _recordSwipe(SwipeConstants.swipeLeft);
      _moveToNextCard();
    }
  }

  void _showContextOverlay() {
    // Placeholder for context overlay (Anton mode)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Context overlay triggered'),
        duration: Duration(milliseconds: 500),
      ),
    );
    _recordSwipe(SwipeConstants.swipeLeft);
    _moveToNextCard();
  }

  void _handleSwipeRight() async {
    final TaxLien property = _cardStack[_currentIndex];
    final expertId = Provider.of<ExpertProfileService>(context, listen: false).currentProfile.id;
    
    // Регистрируем интерес в семейном совете
    FamilyBoardService.instance.registerInterest(property, expertId);

    _recordSwipe(SwipeConstants.swipeRight);
    
    // ... логика мэтча ...
    final matchService = MatchService.instance;
    final isMatch = matchService.isMatch(
      property: property,
      preferences: _preferences,
    );

    if (isMatch && widget.userId != null) {
      final match = matchService.createMatch(
        userId: widget.userId!,
        property: property,
        preferences: _preferences,
      );

      // Show match notification after card animates away
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          MatchNotificationModal.show(
            context: context,
            match: match,
            onViewProperty: () {
              context.pushNamed(
                'details',
                pathParameters: {
                  'state': property.state.toLowerCase(),
                  'county': property.county.toLowerCase(),
                  'id': property.id,
                },
              );
            },
          );
        }
      });
    }

    _moveToNextCard();
  }

  void _handleSwipeUp() {
    _recordSwipe(SwipeConstants.swipeUp);
    _moveToNextCard();
    _showWatchlistConfirmation();
  }

  void _handleSwipeDown() {
    _recordSwipe(SwipeConstants.swipeDown);
    _moveToNextCard();
  }

  void _recordSwipe(String direction) async {
    // Increment daily limit counter
    await DailyLimitService.instance.incrementSwipeCount();

    _swipeCount++;

    // Check daily limit for free users
    final canSwipe = await DailyLimitService.instance.canSwipe(
      isPremium: widget.isPremium,
    );

    if (!canSwipe) {
      _showLimitReachedDialog();
      return;
    }

    // Add to history for undo
    if (_currentIndex < _cardStack.length) {
      _swipeHistory.add(_cardStack[_currentIndex]);
    }

    // TODO: Send to backend
    // _swipeService.recordSwipe(propertyId, direction);

    // Check if approaching limit and show warning
    final warning = await DailyLimitService.instance.getLimitWarning(
      isPremium: widget.isPremium,
    );
    if (warning != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(warning),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _moveToNextCard() {
    setState(() {
      _currentIndex++;
    });

    // Load more if needed
    if (_cardStack.length - _currentIndex < SwipeConstants.prefetchCount) {
      _loadMoreProperties();
    }

    // Check if out of cards
    if (_currentIndex >= _cardStack.length) {
      _showNoMoreCardsDialog();
    }
  }

  void _handleUndo() async {
    if (_swipeHistory.isEmpty) return;
    final undoLimitMessage = AppLocalizations.of(context)!.undoLimitReached;

    // Check undo limit for free users
    final canUndo = await DailyLimitService.instance.canUndo(
      isPremium: widget.isPremium,
    );

    if (!canUndo) {
      if (!mounted) return;
      _showUpgradeDialog(undoLimitMessage);
      return;
    }

    // Increment undo counter
    await DailyLimitService.instance.incrementUndoCount();
    await DailyLimitService.instance.decrementSwipeCount();

    setState(() {
      _currentIndex--;
      _swipeHistory.removeLast();
      _swipeCount--;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(SwipeConstants.successUndo),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showWatchlistConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(SwipeConstants.successAddedToWatchlist),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLimitReachedDialog() async {
    final timeUntilReset = await DailyLimitService.instance.getTimeUntilResetFormatted();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dailyLimitReached),
        content: Text(
          '${SwipeConstants.errorDailyLimitReached}\n\n${l10n.resetIn(timeUntilReset)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.maybeLater),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to paywall
            },
            child: Text(l10n.upgradeNow),
          ),
        ],
      ),
    );
  }

  void _showNoMoreCardsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.noMoreProperties),
        content: Text(SwipeConstants.errorNoMoreCards),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _swipeCount = 0;
                _swipeHistory.clear();
              });
              _loadProperties();
            },
            child: Text(l10n.startOver),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(String reason) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.upgradeToPremium),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to paywall
            },
            child: Text(l10n.upgradeNow),
          ),
        ],
      ),
    );
  }

  void _openPreferences() async {
    final result = await Navigator.push<UserPreferences>(
      context,
      MaterialPageRoute(
        builder: (context) => SwipePreferencesScreen(
          initialPreferences: _preferences,
          onSave: (prefs) {
            setState(() {
              _preferences = prefs;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _preferences = result;
      });
    }
  }

  void _shareCurrentProperty() {
    if (_currentIndex < _cardStack.length) {
      final property = _cardStack[_currentIndex];
      SharePropertySheet.show(
        context: context,
        property: property,
        referralCode: widget.userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileService = Provider.of<ExpertProfileService>(context);
    final currentProfile = profileService.currentProfile;

    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: currentProfile.color,
            radius: 16,
            child: Text(
              currentProfile.name[0],
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          onSelected: (id) => profileService.switchProfile(id),
          itemBuilder: (context) => ExpertProfile.allProfiles.map((p) => 
            PopupMenuItem(
              value: p.id,
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: p.color, radius: 12),
                  const SizedBox(width: 8),
                  Text(p.name),
                ],
              ),
            )
          ).toList(),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appTitle,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${l10n.expert}: ${currentProfile.name}',
                  style: TextStyle(fontSize: 11, color: currentProfile.color),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _foreclosureFilterMode ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: _foreclosureFilterMode ? Colors.orange : null,
            ),
            tooltip: _foreclosureFilterMode
                ? AppLocalizations.of(context)!.foreclosureModeOn
                : AppLocalizations.of(context)!.foreclosureModeOff,
            onPressed: _toggleForeclosureFilter,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCurrentProperty,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openPreferences,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: FittedBox(
                child: Text(
                  '$_swipeCount/${widget.isPremium ? '∞' : SwipeConstants.freeDailySwipeLimit}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SmartBanner(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _buildCardStack(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProperties,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    final l10n = AppLocalizations.of(context)!;
    if (_currentIndex >= _cardStack.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              l10n.noMoreProperties,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n.checkBackLater),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  _swipeCount = 0;
                  _swipeHistory.clear();
                });
                _loadProperties();
              },
              child: Text(l10n.startOver),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Card stack (show up to 3 cards)
        ...List.generate(
          math.min(SwipeConstants.visibleCardCount,
              _cardStack.length - _currentIndex),
          (index) {
            final cardIndex = _currentIndex + index;
            final property = _cardStack[cardIndex];
            final isFront = index == 0;

            return Positioned.fill(
              top: index * SwipeConstants.cardVerticalOffset,
              child: Center(
                child: Transform.scale(
                  scale: 1.0 -
                      (index * SwipeConstants.cardScaleDecrement),
                  child: SwipeablePropertyCard(
                    property: property,
                    isFront: isFront,
                    onSwipeLeft: isFront ? _handleSwipeLeft : null,
                    onSwipeRight: isFront ? _handleSwipeRight : null,
                    onSwipeUp: isFront ? _handleSwipeUp : null,
                    onSwipeDown: isFront ? _handleSwipeDown : null,
                    onTap: isFront ? () {
                      context.pushNamed(
                        'details',
                        pathParameters: {
                          'state': property.state.toLowerCase(),
                          'county': property.county.toLowerCase(),
                          'id': property.id,
                        },
                      );
                    } : null,
                  ),
                ),
              ),
            );
          },
        ).reversed.toList(),

        // Action buttons at bottom
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: ActionButtons(
            onPass: _handleSwipeLeft,
            onLike: _handleSwipeRight,
            onSuperLike: _handleSwipeUp,
            onUndo: _swipeHistory.isNotEmpty ? _handleUndo : null,
          ),
        ),
      ],
    );
  }
}
