// lib/core/services/push_notifications.dart

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/routes/route_names.dart';

class PushNotifications {
  // ── Singletons ────────────────────────────────────────────────
  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  // ── State ─────────────────────────────────────────────────────
  static GoRouter? _router;
  static StreamSubscription<String>? _tokenRefreshSub;
  static StreamSubscription<RemoteMessage>? _onMessageSub;
  static StreamSubscription<RemoteMessage>? _onMessageOpenedSub;

  static String? _cachedToken;
  static String? get cachedToken => _cachedToken;

  // Android channel id (must match what's used in `show()`)
  static const _channelId = 'high_importance_channel';
  static const _channelName = 'High Importance Notifications';
  static const _channelDescription =
      'Important alerts, order updates, and delivery notifications.';

  // ══════════════════════════════════════════════════════════════
  // INIT — call once from main() BEFORE runApp
  // ══════════════════════════════════════════════════════════════
  static Future<void> init(GoRouter router) async {
    _router = router;

    // 1. Initialize the local notifications plugin (for foreground display)
    await _initLocalNotifications();

    // 2. Request permission (iOS + Web; Android auto-grants on <=12)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Push notifications denied by user');
      return;
    }

    // 3. Attach listeners
    _attachListeners();

    // 4. Fetch the initial FCM token
    await _refreshToken();
  }

  // ══════════════════════════════════════════════════════════════
  // LOCAL NOTIFICATIONS SETUP
  // ══════════════════════════════════════════════════════════════
  static Future<void> _initLocalNotifications() async {
    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init (request permission handled by FCM already, so we can
    // leave the defaults — but if you want foreground presentation
    // options, set them here)
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onLocalNotificationTap,
    );

    // Create Android channel (required on Android 8+)
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // ══════════════════════════════════════════════════════════════
  // LISTENERS
  // ══════════════════════════════════════════════════════════════
  static void _attachListeners() {
    // Foreground message → show a local notification
    _onMessageSub?.cancel();
    _onMessageSub = FirebaseMessaging.onMessage.listen(_handleForeground);

    // Background message → user tapped the notification
    _onMessageOpenedSub?.cancel();
    _onMessageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleTap,
    );

    // App was launched from a notification (while terminated)
    _messaging.getInitialMessage().then((initial) {
      if (initial != null) _handleTap(initial);
    });

    // Token refresh
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');
      _cachedToken = newToken;
      _registerWithBackend(newToken);
    });
  }

  // ══════════════════════════════════════════════════════════════
  // FOREGROUND HANDLER
  // ══════════════════════════════════════════════════════════════
  static Future<void> _handleForeground(RemoteMessage message) async {
    debugPrint('FCM foreground: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) {
      // Data-only message in foreground. If you want to show it,
      // pull title/body out of `message.data` and call _show().
      final title = message.data['title'] as String?;
      final body = message.data['body'] as String?;
      if (title != null || body != null) {
        await _show(
          id: message.hashCode,
          title: title ?? 'Notification',
          body: body ?? '',
          payload: message.data.toString(),
        );
      }
      return;
    }

    await _show(
      id: message.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: message.data.toString(),
      imageUrl: notification.android?.imageUrl,
    );
  }

  // ══════════════════════════════════════════════════════════════
  // SHOW LOCAL NOTIFICATION
  // ══════════════════════════════════════════════════════════════
  static Future<void> _show({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      styleInformation: imageUrl != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imageUrl),
              contentTitle: title,
              summaryText: body,
            )
          : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  // ══════════════════════════════════════════════════════════════
  // TAP HANDLERS
  // ══════════════════════════════════════════════════════════════
  /// Called when the user taps a notification while the app is
  /// backgrounded or terminated.
  static void _handleTap(RemoteMessage message) {
    debugPrint('FCM tap: ${message.data}');

    // Prefer a route supplied in the notification payload
    final route = message.data['route'] as String?;
    if (route != null && route.isNotEmpty) {
      _routeFromData(message.data);
      return;
    }

    // Fallback: open the notifications screen
    _router?.goNamed(RouteNames.notificationName);
  }

  /// Called when the user taps a local (foreground) notification.
  static void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    // Payload is the raw map stringified — try to parse it back to
    // route/extra. For simplicity, use a delimited format:
    //   "route=orderHistory&extra=abc123"
    final route = _extractFromPayload(payload, 'route');
    final extra = _extractFromPayload(payload, 'extra');
    if (route == null) return;

    _router?.goNamed(route, extra: extra);
  }

  static void _routeFromData(Map<String, dynamic> data) {
    final route = data['route'] as String?;
    final extra = data['extra'];
    if (route == null) return;
    _router?.goNamed(route, extra: extra);
  }

  // ══════════════════════════════════════════════════════════════
  // TOKEN MANAGEMENT
  // ══════════════════════════════════════════════════════════════
  static Future<void> _refreshToken() async {
    try {
      // ignore: deprecated_member_use
      final token = await _messaging.getToken();
      if (token == null) return;
      _cachedToken = token;
      debugPrint('FCM initial token: $token');
      _registerWithBackend(token);
    } catch (e) {
      debugPrint('FCM token error: $e');
    }
  }

  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    await _refreshToken();
    return _cachedToken;
  }

  /// Called after login to associate the device with the current user.
  static Future<void> registerCurrentDevice() async {
    final token = await getToken();
    if (token == null) return;
    await _registerWithBackend(token);
  }

  static Future<void> _registerWithBackend(String token) async {
    // 
    //
    //   final api = ServiceLocator.apiClient;
    //   await api.post('/devices', body: {
    //     'fcm_token': token,
    //     'platform': defaultTargetPlatform.name,
    //   });
    //
    debugPrint('FCM token → backend: $token');
  }

  // ══════════════════════════════════════════════════════════════
  // PAYLOAD HELPERS
  // ══════════════════════════════════════════════════════════════
  static String? _extractFromPayload(String payload, String key) {
    // Payload comes in as the `.toString()` of the data map,
    // e.g. "{route: orderHistory, extra: abc123}"
    final match = RegExp('$key:\\s*([^,}]+)').firstMatch(payload);
    return match?.group(1)?.trim();
  }

  // ══════════════════════════════════════════════════════════════
  // CLEANUP
  // ══════════════════════════════════════════════════════════════
  static Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _onMessageSub?.cancel();
    await _onMessageOpenedSub?.cancel();
    _tokenRefreshSub = null;
    _onMessageSub = null;
    _onMessageOpenedSub = null;
  }
}
