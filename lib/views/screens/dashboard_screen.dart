import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/auth_viewmodel.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/views/widgets/calories_card.dart';
import 'package:nutripal/views/widgets/macros_card.dart';
import 'package:nutripal/views/widgets/water_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    final diaryRecordState = ref.watch(diaryRecordViewModelProvider);
    ref.read(diaryRecordViewModelProvider.notifier).changeDate(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 18),
            child: IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              icon: const Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
        title: Skeletonizer(
          enabled: authState.isLoading,
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chào mừng,",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  authState.when(
                    data: (user) => user?.username ?? "User",
                    error: (_, _) => "Lỗi",
                    loading: () => "Đang tải...",
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
          child: Skeletonizer(
            enabled: diaryRecordState.isLoading,
            child: Column(
              children: [
                const SizedBox(height: 28),
                const CaloriesCard(),
                const SizedBox(height: 20),
                const MacrosCard(),
                const SizedBox(height: 20),
                const WaterCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
