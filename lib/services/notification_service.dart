import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'it_sahayata_channel',
      'IT Sahayata Notifications',
      channelDescription: 'App ticket/chat notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    await _notifications.show(id, title, body,
        NotificationDetails(android: androidDetails, iOS: iosDetails));
  }
}
