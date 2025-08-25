import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:timezone/data/latest.dart" as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const int _waterReminderBaseId = 1000;

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

  Future<void> scheduleDailyWaterReminders() async {
    await cancelWaterReminders();

    const androidDetails = AndroidNotificationDetails(
      "water_reminder_daily",
      "Nhắc nhở uống nước hàng ngày",
      channelDescription: "Thông báo nhắc nhở uống nước từ 8h sáng đến 8h tối",
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int hour = 8; hour <= 20; hour++) {
      final scheduledTime = today.add(Duration(hours: hour));

      final actualScheduledTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
        actualScheduledTime,
        tz.local,
      );

      final notificationId = _waterReminderBaseId + hour;

      await _notifications.zonedSchedule(
        notificationId,
        "💧 Đã đến giờ uống nước!",
        _getRandomWaterMessage(),
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  String _getRandomWaterMessage() {
    final messages = [
      "Bạn đã uống nước chưa? Hãy bổ sung nước để duy trì sức khoẻ tốt nhất!",
      "Đừng quên uống nước! Cơ thể bạn đang cần nước.",
      "Thời gian uống nước đã đến! 💧",
      "Hãy duy trì đủ nước cho cơ thể bạn!",
      "Uống nước thường xuyên để giữ gìn sức khỏe!",
      "Cơ thể bạn cần nước! Hãy uống một ly nước ngay.",
    ];

    final now = DateTime.now();
    final index = now.hour % messages.length;
    return messages[index];
  }

  Future<void> cancelWaterReminders() async {
    for (int hour = 8; hour <= 20; hour++) {
      final notificationId = _waterReminderBaseId + hour;
      await _notifications.cancel(notificationId);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
