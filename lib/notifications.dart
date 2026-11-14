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

  static Future<void> initialize() => _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
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
    final row = await (database.select(
      database.deviceSettings,
    )..where((s) => s.key.equals(asked))).getSingleOrNull();
    if (row != null) return;
    await database
        .into(database.deviceSettings)
        .insert(DeviceSettingsCompanion.insert(key: asked, value: 'true'));
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

  static Future<void> show(int id, String title, String body) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: _details,
  );
}
