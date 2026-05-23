import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/models/tax_lien_models.dart';
import '../../core/repositories/data_repository.dart';
import '../../services/image_cache_service.dart';
import '../../core/models/device_capabilities.dart';

class DetailsProvider extends ChangeNotifier {
  final IDataRepository _dataRepository;
  final ImageCacheService _imageCacheService;

  TaxLien? _property;
  bool _isLoading = false;
  String? _errorMessage;

  TaxLien? get property => _property;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DetailsProvider({
    required IDataRepository dataRepository,
    required ImageCacheService imageCacheService,
  })  : _dataRepository = dataRepository,
        _imageCacheService = imageCacheService;

  Future<void> loadProperty(String propertyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedProperty = await _dataRepository.getPropertyById(propertyId);
      if (fetchedProperty != null) {
        _property = fetchedProperty;
      } else {
        _errorMessage = 'Property not found.';
      }
    } catch (e) {
      _errorMessage = 'Failed to load property: $e';
      debugPrint('Error loading property in DetailsProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<FileInfo?> getCachedImageFile(String imageUrl, BuildContext context, {bool isUltraRes = false}) async {
    final caps = DeviceCapabilities.of(context);
    return _imageCacheService.getCachedImageFile(imageUrl, caps, isUltraRes: isUltraRes);
  }
}
