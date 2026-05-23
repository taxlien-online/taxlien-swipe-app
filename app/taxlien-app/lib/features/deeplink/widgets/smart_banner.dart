import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/env_config.dart';

class SmartBanner extends StatefulWidget {
  const SmartBanner({super.key});

  @override
  State<SmartBanner> createState() => _SmartBannerState();
}

class _SmartBannerState extends State<SmartBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    // Only show on Web + Mobile (or just Web for simplicity here as requested)
    if (!kIsWeb || !_isVisible) return const SizedBox.shrink();

    final platform = defaultTargetPlatform;
    String? storeUrl;
    String storeName = '';

    if (platform == TargetPlatform.iOS) {
      storeUrl = EnvConfig.storeApple;
      storeName = 'App Store';
    } else if (platform == TargetPlatform.android) {
      // Priority: Google Play -> others from env
      storeUrl = EnvConfig.storeGooglePlay;
      storeName = 'Google Play';
      
      if (storeUrl.isEmpty) {
        final available = EnvConfig.availableStores;
        if (available.isNotEmpty) {
          storeUrl = available.first['url'];
          storeName = available.first['name'] ?? 'Store';
        }
      }
    }

    if (storeUrl == null || storeUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[900],
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () => setState(() => _isVisible = false),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.ads_click, color: Colors.deepPurple), // Placeholder icon
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Deal Detective App',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Open in $storeName',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(storeUrl!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('GET'),
          ),
        ],
      ),
    );
  }
}
