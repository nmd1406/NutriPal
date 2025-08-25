import 'package:nutripal/services/notification_service.dart';

class WaterReminderService {
  final NotificationService _notificationService;

  WaterReminderService(this._notificationService);

  Future<void> initializeDailyReminders() async {
    await _notificationService.scheduleDailyWaterReminders();
  }

  Future<void> stopReminders() async {
    await _notificationService.cancelWaterReminders();
  }

  Future<void> restartDailyReminders() async {
    await stopReminders();
    await initializeDailyReminders();
  }
}
