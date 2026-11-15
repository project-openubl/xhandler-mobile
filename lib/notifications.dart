import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'data/database.dart';

/// Local notifications, e.g. SUNAT answers to documents sent in the
/// background
abstract final class Notifications {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'sunat',
      'Respuestas de SUNAT',
      channelDescription: 'Cuando SUNAT responde un comprobante',
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Opens the document of a tapped notification; set by the app
  static void Function(String documentId)? onOpenDocument;

  static Future<void> initialize() => _plugin.initialize(
    onDidReceiveNotificationResponse: (response) {
      final documentId = response.payload;
      if (documentId != null) onOpenDocument?.call(documentId);
    },
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
  );

  /// Asks for permission the first time it's useful (a document left for
  /// the background outbox), once per install
  static Future<void> requestPermissionOnce(AppDatabase database) async {
    const asked = 'notifications_asked';
    if (await database.setting(asked) != null) return;
    await database.setSetting(asked, 'true');
    await initialize();
    await _requestPermission();
  }

  static Future<void> _requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true);
  }

  /// Shows a notification about the document [documentId], which opens it
  static Future<void> show(
    int id,
    String title,
    String body, {
    required String documentId,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: _details,
    payload: documentId,
  );

  static var _launchHandled = false;

  /// The document whose notification was tapped to start the app, if any.
  /// Only the first call answers: a restarted app (e.g. after restoring a
  /// backup) wasn't launched by it again.
  static Future<String?> launchDocument() async {
    if (_launchHandled) return null;
    _launchHandled = true;
    final launch = await _plugin.getNotificationAppLaunchDetails();
    return launch?.didNotificationLaunchApp ?? false
        ? launch?.notificationResponse?.payload
        : null;
  }
}
