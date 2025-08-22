import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/services/notification_service.dart';
import 'package:nutripal/services/water_reminder_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final waterReminderServiceProvider = Provider<WaterReminderService>((ref) {
  final notificationService = ref.read(notificationServiceProvider);
  return WaterReminderService(notificationService);
});
