import 'package:nutripal/models/water_record.dart';
import 'package:nutripal/services/notification_service.dart';

class WaterReminderService {
  final NotificationService _notificationService;

  WaterReminderService(this._notificationService);

  Future<void> scheduleNextReminder(List<WaterRecord> todayRecords) async {
    final now = DateTime.now();
    final nextReminderTime = _getNextReminderTime(now);

    await _notificationService.scheduleNotification(nextReminderTime);
  }

  DateTime _getNextReminderTime(DateTime now) {
    final currentHour = now.hour;

    if (currentHour >= 8 && currentHour < 20) {
      final nextHour = now.add(const Duration(hours: 1));
      return nextHour;
    } else if (currentHour < 8) {
      final today = DateTime(now.year, now.month, now.day, 8, 0);
      return today;
    }
    return DateTime(now.year, now.month, now.day + 1, 8, 0);
  }
}
