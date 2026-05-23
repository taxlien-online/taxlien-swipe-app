import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

import '../core/models/device_capabilities.dart'; // For DeviceCapabilities

/// Service to handle caching and pre-fetching of images
class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService({DefaultCacheManager? cacheManager}) => 
      _instance._init(cacheManager);
  ImageCacheService._internal();

  late DefaultCacheManager _cacheManager;

  ImageCacheService _init(DefaultCacheManager? cacheManager) {
    _cacheManager = cacheManager ?? DefaultCacheManager();
    return _instance;
  }

  /// Prefetches images for a list of property image URLs.
  /// Applies a two-tier strategy:
  /// - `ultraResCount`: Fetches source-max quality for these.
  /// - Rest: Fetches device-max quality.
  Future<void> prefetchImages(
    List<String> imageUrls, {
    int ultraResCount = 0,
    required DeviceCapabilities caps,
  }) async {
    for (int i = 0; i < imageUrls.length; i++) {
      final imageUrl = imageUrls[i];
      Uri uri;

      if (i < ultraResCount) {
        // Request source-max quality for a subset of images
        uri = buildOptimizedImageUrl(imageUrl, caps, isUltraRes: true);
        debugPrint('Prefetching ULTRA-RES image: ${uri.toString()}');
      } else {
        // Request device-max quality for the rest
        uri = buildOptimizedImageUrl(imageUrl, caps);
        debugPrint('Prefetching DEVICE-MAX image: ${uri.toString()}');
      }

      try {
        await _cacheManager.downloadFile(uri.toString(), key: uri.toString());
      } catch (e) {
        debugPrint('Error prefetching image ${uri.toString()}: $e');
      }
    }
  }

  /// Builds an optimized image URL based on device capabilities and desired quality.
  /// This method assumes the Gateway API's image proxy supports parameters like 'w', 'h', 'dpr', 'quality'.
  /// Made public for testing and external use.
  Uri buildOptimizedImageUrl(String baseUrl, DeviceCapabilities caps, {bool isUltraRes = false}) { // Made public
    final uri = Uri.parse(baseUrl);
    final queryParameters = Map<String, String>.from(uri.queryParameters);

    if (isUltraRes) {
      queryParameters['quality'] = 'source'; 
    } else {
      queryParameters['w'] = (caps.maxWidth * caps.pixelRatio).round().toString();
      queryParameters['h'] = (caps.maxHeight * caps.pixelRatio).round().toString();
      queryParameters['dpr'] = caps.pixelRatio.toString();
    }
    
    if (isUltraRes && (queryParameters.containsKey('w') || queryParameters.containsKey('h') || queryParameters.containsKey('dpr'))) {
      queryParameters.remove('w');
      queryParameters.remove('h');
      queryParameters.remove('dpr');
    }

    return uri.replace(queryParameters: queryParameters);
  }

  /// Get a cached image file.
  Future<FileInfo?> getCachedImageFile(String imageUrl, DeviceCapabilities caps, {bool isUltraRes = false}) async {
    final uri = buildOptimizedImageUrl(imageUrl, caps, isUltraRes: isUltraRes);
    return await _cacheManager.getFileFromCache(uri.toString());
  }
}
