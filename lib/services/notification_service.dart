import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:timezone/data/latest.dart" as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
    await _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Permission.notification.request();

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> scheduleNotification(DateTime scheduledTime) async {
    await _notifications.cancel(1);

    const androidDetails = AndroidNotificationDetails(
      "water_reminder",
      "Nhắc nhở uống nước",
      channelDescription: "Thông báo nhắc nhở uống nước định kỳ",
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final tz.TZDateTime tzScheduledateTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    _notifications.zonedSchedule(
      1,
      "Đã đến giờ uống nước!",
      "Bạn đã uống nước chưa? Hãy bổ sung nước để duy trì sức khoẻ tốt nhất!",
      tzScheduledateTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
