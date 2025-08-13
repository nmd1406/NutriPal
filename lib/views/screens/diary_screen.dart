import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/meal_record.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/viewmodels/water_tracking_viewmodel.dart';
import 'package:nutripal/views/widgets/date_selector.dart';
import 'package:nutripal/views/widgets/meal_diary_tile.dart';
import 'package:nutripal/views/widgets/water_diary_tile.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({super.key});

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  DateTime _selectedDate = DateTime.now();

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    ref
        .read(mealTrackingViewModelProvider.notifier)
        .changeSelectedDate(_selectedDate);
    ref
        .read(waterTrackingViewModelProvider.notifier)
        .changeSelectedDate(_selectedDate);
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    ref
        .read(mealTrackingViewModelProvider.notifier)
        .changeSelectedDate(_selectedDate);
    ref
        .read(waterTrackingViewModelProvider.notifier)
        .changeSelectedDate(_selectedDate);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      ref
          .read(mealTrackingViewModelProvider.notifier)
          .changeSelectedDate(_selectedDate);
      ref
          .read(waterTrackingViewModelProvider.notifier)
          .changeSelectedDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tdee = ref.watch(tdeeProvider).round();

    final mealTrackingState = ref.watch(mealTrackingViewModelProvider);
    final int totalDailyCalories = mealTrackingState.totalDailyCalories.round();

    return Scaffold(
      appBar: AppBar(title: Text("Nhật ký")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateSelector(
              selectedDate: _selectedDate,
              onPreviousDay: _previousDay,
              onNextDay: _nextDay,
              onDateTap: _selectDate,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.4),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lượng calo còn lại", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              tdee.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Mục tiêu",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        Text("-", style: TextStyle(fontSize: 32)),
                        Column(
                          children: [
                            Text(
                              totalDailyCalories.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Thực phẩm",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        Text("=", style: TextStyle(fontSize: 26)),
                        Column(
                          children: [
                            Text(
                              "${tdee - totalDailyCalories}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Còn lại",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MealDiaryTile(meal: Meal.breakfast),
            const SizedBox(height: 10),
            MealDiaryTile(meal: Meal.lunch),
            const SizedBox(height: 10),
            MealDiaryTile(meal: Meal.dinner),
            const SizedBox(height: 10),
            MealDiaryTile(meal: Meal.snack),
            const SizedBox(height: 10),
            const WaterDiaryTile(),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: () {
                // Lưu lên firebase
              },
              child: Text("Cập nhật nhật ký"),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
