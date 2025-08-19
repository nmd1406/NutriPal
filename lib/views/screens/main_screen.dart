import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/viewmodels/navigation_viewmodel.dart';
import 'package:nutripal/views/screens/add_food_screen.dart';
import 'package:nutripal/views/screens/add_water_screen.dart';
import 'package:nutripal/views/screens/weight_record_screen.dart';
import 'package:nutripal/views/screens/dashboard_screen.dart';
import 'package:nutripal/views/screens/diary_screen.dart';
import 'package:nutripal/views/screens/more_screen.dart';
import 'package:nutripal/views/screens/stats_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationViewModelProvider);
    final diaryNotifier = ref.read(diaryRecordViewModelProvider.notifier);

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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    onTap: () {
                      diaryNotifier.changeDate(DateTime.now());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddFoodScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.restaurant, color: Colors.orange),
                    title: Text(
                      "Thực phẩm",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      diaryNotifier.changeDate(DateTime.now());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddWaterScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.water_drop, color: Colors.blue),
                    title: Text(
                      "Nước",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WeightRecordScreen(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.monitor_weight,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Cân nặng",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
