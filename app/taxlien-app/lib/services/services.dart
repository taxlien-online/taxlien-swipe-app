/// Tax Lien App Services
///
/// Platform services for notifications, system tray, etc.
///
/// Usage:
/// ```dart
/// import 'package:taxlien_swipe_app/services/services.dart';
///
/// // Initialize notification service
/// final notifications = NotificationService();
/// await notifications.initialize();
/// await notifications.requestPermission();
///
/// // Show a local notification
/// await notifications.showLocal(
///   title: 'New Property Match',
///   body: 'A property matching your criteria was found!',
/// );
///
/// // System tray (desktop only)
/// final tray = TrayService();
/// await tray.initialize();
/// await tray.updateMenu(defaultTrayMenu());
/// ```
library;

export 'notification_service.dart';
export 'tray_service.dart';
