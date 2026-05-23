import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// Payload received when a notification is tapped.
class NotificationPayload {
  const NotificationPayload({
    this.propertyId,
    this.route,
    this.data,
  });

  /// The property ID if the notification is about a specific property.
  final String? propertyId;

  /// The route to navigate to.
  final String? route;

  /// Additional data from the notification.
  final Map<String, dynamic>? data;

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      propertyId: map['propertyId'] as String?,
      route: map['route'] as String?,
      data: map,
    );
  }
}

/// Abstract notification service for push and local notifications.
///
/// Implement platform-specific versions as needed.
abstract class NotificationService {
  /// Initialize the notification service.
  Future<void> initialize();

  /// Request notification permissions.
  ///
  /// Returns true if permissions were granted.
  Future<bool> requestPermission();

  /// Show a local notification.
  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
    int? id,
  });

  /// Get the push notification token (for remote notifications).
  ///
  /// Returns null if push notifications are not available.
  Future<String?> getToken();

  /// Stream of notification payloads when notifications are tapped.
  Stream<NotificationPayload> get onNotificationTapped;

  /// Check if notifications are enabled.
  Future<bool> isEnabled();

  /// Cancel a specific notification.
  Future<void> cancel(int id);

  /// Cancel all notifications.
  Future<void> cancelAll();

  /// Factory to get the appropriate implementation.
  factory NotificationService() {
    if (kIsWeb) {
      return _NoOpNotificationService();
    }
    // On real implementation, return platform-specific service
    return _NoOpNotificationService();
  }
}

/// No-op implementation for platforms without notification support.
class _NoOpNotificationService implements NotificationService {
  final _controller = StreamController<NotificationPayload>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {}

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<NotificationPayload> get onNotificationTapped => _controller.stream;

  @override
  Future<bool> isEnabled() async => false;

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}
}

/// Implementation using flutter_local_notifications + firebase_messaging.
///
/// Uncomment and configure when dependencies are properly set up.
/*
class MobileNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _localPlugin;
  final FirebaseMessaging _messaging;
  final _controller = StreamController<NotificationPayload>.broadcast();

  MobileNotificationService({
    FlutterLocalNotificationsPlugin? localPlugin,
    FirebaseMessaging? messaging,
  })  : _localPlugin = localPlugin ?? FlutterLocalNotificationsPlugin(),
        _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  Future<void> initialize() async {
    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localPlugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Handle Firebase messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check for initial message (app opened from notification)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  @override
  Future<bool> requestPermission() async {
    // Request local notification permission
    if (Platform.isIOS || Platform.isMacOS) {
      final result = await _localPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      if (result != true) return false;
    }

    // Request Firebase permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'taxlien_channel',
      'Tax Lien Notifications',
      channelDescription: 'Notifications for tax lien properties',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localPlugin.show(
      id ?? DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Stream<NotificationPayload> get onNotificationTapped => _controller.stream;

  @override
  Future<bool> isEnabled() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  @override
  Future<void> cancel(int id) => _localPlugin.cancel(id);

  @override
  Future<void> cancelAll() => _localPlugin.cancelAll();

  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      _controller.add(NotificationPayload.fromMap(
        {'route': response.payload},
      ));
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification for foreground messages
    final notification = message.notification;
    if (notification != null) {
      showLocal(
        title: notification.title ?? 'Deal Detective',
        body: notification.body ?? '',
        payload: message.data['route'] as String?,
      );
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    _controller.add(NotificationPayload(
      propertyId: message.data['propertyId'] as String?,
      route: message.data['route'] as String?,
      data: message.data,
    ));
  }
}
*/
