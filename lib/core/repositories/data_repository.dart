import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

import '../../services/tax_lien_service.dart';
import '../../services/image_cache_service.dart'; // New Import
import '../config/env_config.dart';
import '../database/database_service.dart';
import '../models/tax_lien_models.dart';
import '../models/device_capabilities.dart'; // New Import

/// Abstract interface for the Data Repository.
/// Defined in 02-specifications.md
abstract class IDataRepository {
  Stream<List<TaxLien>> getPropertiesStream(String filterContextHash);
  Future<void> queueAction(String type, Map<String, dynamic> payload);
  Future<void> prefetchBatch({required int limit, required int ultraResLimit, required DeviceCapabilities caps});
  Future<void> updatePropertyLikedStatus(String propertyId, bool isLiked);
}

class DataRepository implements IDataRepository {
  final DatabaseService _dbService;
  final TaxLienService _apiService;
  final Connectivity _connectivity;
  final ImageCacheService _imageCacheService; // New Field

  // Stream controller to emit property updates to the UI
  final _propertiesController = StreamController<List<TaxLien>>.broadcast();

  DataRepository({
    required DatabaseService dbService,
    required TaxLienService apiService,
    required Connectivity connectivity,
    required ImageCacheService imageCacheService, // New Parameter
  })  : _dbService = dbService,
        _apiService = apiService,
        _connectivity = connectivity,
        _imageCacheService = imageCacheService { // Initialize new field
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
    // Initial fetch to populate the stream
    _fetchAndEmitProperties();
  }

  // --- Stream Management ---
  @override
  Stream<List<TaxLien>> getPropertiesStream(String filterContextHash) {
    // For now, ignoring filterContextHash in stream, will add proper filtering later.
    _fetchAndEmitProperties(); // Trigger an initial fetch
    return _propertiesController.stream;
  }

  Future<void> _fetchAndEmitProperties() async {
    final cachedProperties = await _dbService.getProperties(limit: EnvConfig.offlineBatchSize * 2); // Fetch more than current batch size
    final taxLiens = cachedProperties.map((e) => TaxLien.fromJson(e)).toList();
    _propertiesController.sink.add(taxLiens);
  }

  // --- Offline Actions ---
  @override
  Future<void> queueAction(String type, Map<String, dynamic> payload) async {
    await _dbService.queueAction(type, payload);
    // Optionally trigger sync if online
    _handleConnectivityChange(await _connectivity.checkConnectivity());
  }

  @override
  Future<void> updatePropertyLikedStatus(String propertyId, bool isLiked) async {
    final db = await _dbService.database;
    await db.update(
      'properties',
      {'is_liked': isLiked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [propertyId],
    );
    // Refresh stream for UI
    _fetchAndEmitProperties();
  }

  // --- Prefetching ---
  @override
  Future<void> prefetchBatch({
    required int limit,
    required int ultraResLimit,
    required DeviceCapabilities caps,
  }) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint('Offline. Cannot prefetch.');
      return;
    }

    // TODO: Implement actual API call to /discovery with filter_context
    // For now, using mock or existing search
    try {
      final List<TaxLien> newProperties = await _apiService.searchLiens(limit: limit); // Using existing for now
      final List<String> imageUrlsToPrefetch = [];

      for (var property in newProperties) {
        final Map<String, dynamic> propertyJson = property.toJson();
        // Add ML scores and FVI back for DB storage, as they are excluded from toJson() by @JsonKey(includeToJson: false)
        propertyJson['foreclosureProbability'] = property.foreclosureProbability;
        propertyJson['miwScore'] = property.miwScore;
        propertyJson['karmaScore'] = property.karmaScore;
        propertyJson['priorYearsOwed'] = property.priorYearsOwed;
        // FVI needs special handling as it's a complex object
        if (property.fvi != null) {
          propertyJson['fvi'] = property.fvi!.toJson();
        }

        // Determine priority score for DB storage
        double priorityScore = 0.0;
        if (property.miwScore != null) priorityScore += property.miwScore!;
        if (property.foreclosureProbability != null) priorityScore += property.foreclosureProbability!;
        // Assigning is_priority for ML/Social content based on some criteria (TBD from API)
        bool isPriority = (property.miwScore ?? 0.0) > 0.7; // Example criteria

        await _dbService.saveProperty(
          {
            'id': property.id,
            'data': json.encode(propertyJson),
            'priority_score': priorityScore,
            'is_priority': isPriority ? 1 : 0,
            // is_liked will be 0 initially for new items
            'last_accessed': DateTime.now().millisecondsSinceEpoch,
            // filter_context_hash TBD: needs to come from the API request or UI state
          },
        );
        imageUrlsToPrefetch.addAll(property.images); // Collect image URLs
      }
      
      // Prefetch images using the ImageCacheService
      await _imageCacheService.prefetchImages(
        imageUrlsToPrefetch,
        ultraResCount: ultraResLimit,
        caps: caps,
      );

      _fetchAndEmitProperties(); // Refresh UI with new data
    } catch (e) {
      debugPrint('Error during prefetch: $e');
    }
  }

  // --- Connectivity Handling ---
  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      debugPrint('Online. Attempting to sync actions and prefetch.');
      await _syncActions();
      // Only prefetch if we are below a certain threshold of items
      final currentCount = await _dbService.getPropertyCount();
      if (currentCount < EnvConfig.offlineBatchSize * 0.5) { // If less than 50% buffer, prefetch
        // TODO: Get actual device capabilities
        final placeholderCaps = DeviceCapabilities(maxWidth: 1080, maxHeight: 1920, pixelRatio: 2.0);
        await prefetchBatch(
          limit: EnvConfig.offlineBatchSize,
          ultraResLimit: (EnvConfig.offlineBatchSize * EnvConfig.ultraResPercent / 100).round(),
          caps: placeholderCaps,
        );
      }
    } else {
      debugPrint('Offline. Actions will be queued.');
    }
  }

  Future<void> _syncActions() async {
    final actions = await _dbService.getQueuedActions();
    if (actions.isEmpty) {
      debugPrint('No actions to sync.');
      return;
    }

    debugPrint('Syncing ${actions.length} actions.');
    // TODO: Implement actual API call to /sync/actions
    // For now, simulate success and delete
    for (var action in actions) {
      try {
        // await _apiService.syncAction(action); // Placeholder
        await _dbService.removeAction(action['id']);
      } catch (e) {
        debugPrint('Failed to sync action ${action['id']}: $e. Will retry later.');
        // Increment retry count, potentially mark for manual review if too many retries
      }
    }
    debugPrint('Actions sync complete (simulated).');
  }

  // --- Cleanup ---
  void dispose() {
    _propertiesController.close();
  }
}
