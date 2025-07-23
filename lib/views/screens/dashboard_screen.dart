import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/auth_viewmodel.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 18),
            child: IconButton.filled(
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
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
    );
  }
}
