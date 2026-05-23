import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config/env_config.dart';

class DeepLinkService {
  static final DeepLinkService instance = DeepLinkService._();
  DeepLinkService._();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  
  final _uriController = StreamController<Uri>.broadcast();
  Stream<Uri> get uriStream => _uriController.stream;

  Future<void> init() async {
    if (kIsWeb) return;

    // Handle initial link (when app is opened via link)
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial app link: $e');
    }

    // Handle incoming links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri),
      onError: (err) => debugPrint('AppLink Stream Error: $err'),
    );
    
    // Check for deferred deep link
    await _checkDeferredLink();
  }

  void _handleUri(Uri uri) {
    debugPrint('Handling deep link: $uri');
    // Only handle links for our domain
    if (uri.host == EnvConfig.webDomain || uri.host.isEmpty) {
      _uriController.add(uri);
    }
  }

  Future<void> _checkDeferredLink() async {
    final prefs = await SharedPreferences.getInstance();
    final hasChecked = prefs.getBool('has_checked_deferred_link') ?? false;
    
    if (hasChecked) return;

    // Mock Deferred Deep Link logic
    // In real scenario: call Backend API with Fingerprint
    await Future.delayed(const Duration(seconds: 2)); // Simulate network call
    
    // For testing/demo: check if there's a stored "pending" path in a mock server
    // Since we don't have a real server, we just mark it as checked.
    await prefs.setBool('has_checked_deferred_link', true);
    
    debugPrint('Deferred deep link check complete (Mock)');
  }

  void dispose() {
    _linkSubscription?.cancel();
    _uriController.close();
  }
}
