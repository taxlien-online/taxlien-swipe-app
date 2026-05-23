import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import '../core/config/env_config.dart';
import '../core/repositories/data_repository.dart';
import '../core/models/device_capabilities.dart';
import 'analytics_service.dart';

class SyncManager {
  final IDataRepository _dataRepository;
  final Connectivity _connectivity;
  final AnalyticsService? _analytics;
  final bool Function() _isSignedIn;
  Timer? _prefetchTimer;
  BuildContext? _context;

  SyncManager({
    required IDataRepository dataRepository,
    required Connectivity connectivity,
    AnalyticsService? analytics,
    bool Function()? isSignedIn,
  })  : _dataRepository = dataRepository,
        _connectivity = connectivity,
        _analytics = analytics,
        _isSignedIn = isSignedIn ?? (() => false) {
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  /// Call this once at app startup with a valid BuildContext
  void initialize(BuildContext context) {
    _context = context;
    _startPrefetchTimer();
    _connectivity.checkConnectivity().then(_handleConnectivityChange);
  }

  void _startPrefetchTimer() {
    // Prefetch periodically (e.g., every 5 minutes if online)
    _prefetchTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      if (result != ConnectivityResult.none && _context != null) {
        debugPrint('SyncManager: Periodic prefetch triggered.');
        await triggerPrefetchIfNeeded();
      }
    });
  }

  /// Triggers a prefetch operation if needed.
  /// This can be called proactively by UI (e.g., after a swipe) or by the timer.
  /// Cloud sync (and prefetch that feeds it) runs only when signed in.
  Future<void> triggerPrefetchIfNeeded() async {
    if (!_isSignedIn()) {
      debugPrint('SyncManager: Not signed in. Cloud sync disabled.');
      return;
    }
    final results = await _connectivity.checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      debugPrint('SyncManager: Offline. Cannot prefetch.');
      return;
    }

    if (_context == null) {
      debugPrint('SyncManager: No BuildContext available for prefetch. Call initialize().');
      return;
    }

    final currentCount = await _dataRepository.getCachedPropertyCount();
    if (currentCount < EnvConfig.offlineBatchSize) {
      debugPrint('SyncManager: Prefetching to top up buffer. Current: $currentCount, Target: ${EnvConfig.offlineBatchSize}');
      final caps = DeviceCapabilities.of(_context!);
      await _dataRepository.prefetchBatch(
        limit: EnvConfig.offlineBatchSize - currentCount,
        ultraResLimit: (EnvConfig.offlineBatchSize * EnvConfig.ultraResPercent / 100).round(),
        caps: caps,
      );
    } else {
      debugPrint('SyncManager: Buffer is full enough ($currentCount items). No prefetch needed.');
    }
  }


  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    if (result != ConnectivityResult.none && _isSignedIn()) {
      debugPrint('SyncManager: Online and signed in. Attempting to sync actions and trigger prefetch.');
      final stopwatch = Stopwatch()..start();
      await _dataRepository.syncQueuedActions();
      stopwatch.stop();
      _analytics?.logEvent('sync_completed', parameters: {
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
      if (_context != null) {
        await triggerPrefetchIfNeeded();
      }
    } else {
      debugPrint('SyncManager: Offline. Actions will be queued.');
      final count = await _dataRepository.getCachedPropertyCount();
      _analytics?.logEvent('offline_mode_entered', parameters: {
        'cached_properties_count': count,
      });
    }
  }

  void dispose() {
    _prefetchTimer?.cancel();
  }
}
