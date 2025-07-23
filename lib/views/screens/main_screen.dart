import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/navigation_viewmodel.dart';
import 'package:nutripal/views/screens/dashboard_screen.dart';
import 'package:nutripal/views/screens/diary_screen.dart';
import 'package:nutripal/views/screens/more_screen.dart';
import 'package:nutripal/views/screens/stats_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationViewModelProvider);

    final screens = const [
      DashboardScreen(),
      DiaryScreen(),
      StatsScreen(),
      MoreScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: child,
          );
        },
        child: Container(
          key: ValueKey<int>(currentIndex),
          child: screens[currentIndex],
        ),
      ),
      floatingActionButton: IconButton.filled(
        iconSize: 40,
        onPressed: () {},
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              iconSize: 30,
              currentIndex: currentIndex,
              onTap: (index) => ref
                  .read(navigationViewModelProvider.notifier)
                  .setIndex(index),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  label: "Trang chủ",
                  icon: Icon(Icons.dashboard),
                ),
                BottomNavigationBarItem(
                  label: "Nhật ký",
                  icon: Icon(Icons.book),
                ),
                BottomNavigationBarItem(
                  label: "Thống kê",
                  icon: Icon(Icons.bar_chart_rounded),
                ),
                BottomNavigationBarItem(
                  label: "Thêm",
                  icon: Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
