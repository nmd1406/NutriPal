import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/auth_viewmodel.dart';
import 'package:nutripal/views/widgets/calories_card.dart';
import 'package:nutripal/views/widgets/macros_card.dart';
import 'package:nutripal/views/widgets/water_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
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
        title: authState.when(
          data: (user) => Padding(
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
                  user?.username ?? "User",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          error: (_, _) => const Text("Lỗi"),
          loading: () => const Text("Đang tải..."),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
          child: Column(
            children: [
              const SizedBox(height: 28),
              CaloriesCard(baseGoal: 1780, food: 700),
              const SizedBox(height: 20),
              MacrosCard(
                baseCarb: 100,
                carbIntake: 54,
                baseFat: 82,
                fatIntake: 42,
                baseProtein: 200,
                proteinIntake: 154,
              ),
              const SizedBox(height: 20),
              const WaterCard(),
            ],
          ),
        ),
      ),
    );
  }
}
