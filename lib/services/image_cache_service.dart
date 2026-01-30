import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:path/path.dart' as p;

import '../core/repositories/data_repository.dart'; // For DeviceCapabilities

/// Service to handle caching and pre-fetching of images
class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final DefaultCacheManager _cacheManager = DefaultCacheManager();

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
        // Assuming the API supports a 'quality=source' or similar parameter
        // Or that 'maxWidth' and 'maxHeight' with max available values implies source-max
        // Example: if image_url is 'base/image.jpg', we might append '?quality=source'
        uri = _buildOptimizedImageUrl(imageUrl, caps, isUltraRes: true);
        debugPrint('Prefetching ULTRA-RES image: ${uri.toString()}');
      } else {
        // Request device-max quality for the rest
        uri = _buildOptimizedImageUrl(imageUrl, caps);
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
  Uri _buildOptimizedImageUrl(String baseUrl, DeviceCapabilities caps, {bool isUltraRes = false}) {
    final uri = Uri.parse(baseUrl);
    final queryParameters = Map<String, String>.from(uri.queryParameters);

    if (isUltraRes) {
      // For ultra-res, request the source quality, possibly ignoring width/height
      // Example: 'quality=source' or 'res=full'
      queryParameters['quality'] = 'source'; // Assuming API understands this
      // Or you might send very large dimensions if source quality is tied to dimensions
      // queryParameters['w'] = '9999'; 
      // queryParameters['h'] = '9999';
    } else {
      // For device-max, use device's capabilities
      queryParameters['w'] = (caps.maxWidth * caps.pixelRatio).round().toString();
      queryParameters['h'] = (caps.maxHeight * caps.pixelRatio).round().toString();
      queryParameters['dpr'] = caps.pixelRatio.toString();
    }
    
    // Ensure we don't accidentally send both, if 'quality=source' is exclusive
    if (isUltraRes && queryParameters.containsKey('w')) {
      queryParameters.remove('w');
      queryParameters.remove('h');
      queryParameters.remove('dpr');
    }

    return uri.replace(queryParameters: queryParameters);
  }

  /// Get a cached image file.
  Future<FileInfo?> getCachedImageFile(String imageUrl, DeviceCapabilities caps, {bool isUltraRes = false}) async {
    final uri = _buildOptimizedImageUrl(imageUrl, caps, isUltraRes: isUltraRes);
    return await _cacheManager.getFileFromCache(uri.toString());
  }

  /// Remove old images based on LRU policy (managed by DefaultCacheManager, but we can clear specific items).
  Future<void> removeImage(String imageUrl) async {
    // This is tricky as we store different URIs for different resolutions.
    // A full clear is easier or use keys directly for the various URIs.
    // For now, rely on DefaultCacheManager's internal LRU.
    // If we need custom LRU beyond DefaultCacheManager, we'd need to track local paths.
  }
}
