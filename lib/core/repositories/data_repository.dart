import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debugPrint

import '../../services/tax_lien_service.dart';
import '../../services/image_cache_service.dart';
import '../config/env_config.dart';
import '../database/database_service.dart';
import '../models/tax_lien_models.dart';
import '../models/device_capabilities.dart';

/// Abstract interface for the Data Repository.
/// Defined in 02-specifications.md
abstract class IDataRepository {
  Stream<List<TaxLien>> getPropertiesStream(String filterContextHash);
  Future<TaxLien?> getPropertyById(String propertyId);
  Future<void> queueAction(String type, Map<String, dynamic> payload);
  Future<void> prefetchBatch({required int limit, required int ultraResLimit, required DeviceCapabilities caps});
  Future<void> updatePropertyLikedStatus(String propertyId, bool isLiked);
  Future<int> getCachedPropertyCount({String? filterContextHash});
  Future<void> syncQueuedActions();
}

class DataRepository implements IDataRepository {
  final DatabaseService _dbService;
  final TaxLienService _apiService;
  final ImageCacheService _imageCacheService;

  // Stream controller to emit property updates to the UI
  final _propertiesController = StreamController<List<TaxLien>>.broadcast();

  DataRepository({
    required DatabaseService dbService,
    required TaxLienService apiService,
    required ImageCacheService imageCacheService,
  })  : _dbService = dbService,
        _apiService = apiService,
        _imageCacheService = imageCacheService {
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
    // DataRepository no longer directly triggers sync, SyncManager handles it.
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
    // DataRepository no longer checks connectivity, SyncManager handles it.

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

  // --- Sync Actions ---
  @override
  Future<void> syncQueuedActions() async {
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

  // --- Exposed for SyncManager ---
  @override
  Future<int> getCachedPropertyCount({String? filterContextHash}) {
    return _dbService.getPropertyCount(contextHash: filterContextHash);
  }

  @override
  Future<TaxLien?> getPropertyById(String propertyId) async {
    final Map<String, dynamic>? propertyMap = await _dbService.getPropertyById(propertyId);
    if (propertyMap != null) {
      // Update last_accessed for LRU
      await _dbService.saveProperty(propertyMap); // This will update last_accessed
      return TaxLien.fromJson(propertyMap);
    }
    // TODO: If not found locally, attempt to fetch from API if online?
    // This is for "Liked" properties that should always be cached first.
    return null;
  }

  // --- Cleanup ---
  void dispose() {
    _propertiesController.close();
  }
}