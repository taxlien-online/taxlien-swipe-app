import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'; // For BuildContext in DeviceCapabilities

import '../core/config/env_config.dart';
import '../core/repositories/data_repository.dart';
import '../core/models/device_capabilities.dart';

class SyncManager {
  final IDataRepository _dataRepository; // Use interface
  final Connectivity _connectivity;
  Timer? _prefetchTimer;
  BuildContext? _context; // To get DeviceCapabilities

  SyncManager({
    required IDataRepository dataRepository, // Use interface
    required Connectivity connectivity,
  })  : _dataRepository = dataRepository,
        _connectivity = connectivity {
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  /// Call this once at app startup with a valid BuildContext
  void initialize(BuildContext context) {
    _context = context;
    _startPrefetchTimer();
    _handleConnectivityChange(ConnectivityResult.none); // Check initial state
  }

  void _startPrefetchTimer() {
    // Prefetch periodically (e.g., every 5 minutes if online)
    _prefetchTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none && _context != null) {
        debugPrint('SyncManager: Periodic prefetch triggered.');
        await _triggerPrefetch();
      }
    });
  }

  /// Triggers a prefetch operation if needed.
  /// This can be called proactively by UI (e.g., after a swipe) or by the timer.
  Future<void> triggerPrefetchIfNeeded() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
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


  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      debugPrint('SyncManager: Online. Attempting to sync actions and trigger prefetch.');
      await _dataRepository.syncQueuedActions();
      if (_context != null) {
        await triggerPrefetchIfNeeded();
      }
    } else {
      debugPrint('SyncManager: Offline. Actions will be queued.');
    }
  }

  void dispose() {
    _prefetchTimer?.cancel();
  }
}
