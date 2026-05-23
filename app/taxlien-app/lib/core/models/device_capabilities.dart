import 'package:flutter/widgets.dart'; // For MediaQuery

/// Represents the device's display capabilities for image fetching.
class DeviceCapabilities {
  final double maxWidth;
  final double maxHeight;
  final double pixelRatio;

  DeviceCapabilities({required this.maxWidth, required this.maxHeight, required this.pixelRatio});

  // Factory constructor to get current device capabilities
  factory DeviceCapabilities.of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return DeviceCapabilities(
      maxWidth: mediaQuery.size.width,
      maxHeight: mediaQuery.size.height,
      pixelRatio: mediaQuery.devicePixelRatio,
    );
  }
}