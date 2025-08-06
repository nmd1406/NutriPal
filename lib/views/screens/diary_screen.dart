import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/meal_record.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/widgets/date_selector.dart';
import 'package:nutripal/views/widgets/meal_diary_card.dart';
import 'package:nutripal/views/widgets/water_diary_card.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({super.key});

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  DateTime selectedDate = DateTime.now();

  void _previousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Nhật ký")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateSelector(
              selectedDate: selectedDate,
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
                    profileState.when(
                      data: (Profile profile) {
                        final mealTrackingState = ref.watch(
                          mealTrackingViewModelProvider,
                        );
                        final int tdee = profile.tdee.round();
                        final int totalDailyCalories = mealTrackingState
                            .totalDailyCalories
                            .round();

                        return Row(
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
                        );
                      },
                      loading: () => const Text("Đang tải..."),
                      error: (_, _) => const Text("Có lỗi xảy ra"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MealDiaryCard(meal: Meal.breakfast),
            const SizedBox(height: 10),
            MealDiaryCard(meal: Meal.lunch),
            const SizedBox(height: 10),
            MealDiaryCard(meal: Meal.dinner),
            const SizedBox(height: 10),
            MealDiaryCard(meal: Meal.snack),
            const SizedBox(height: 10),
            WaterDiary(),
            const SizedBox(height: 36),
            ElevatedButton(onPressed: () {}, child: Text("Cập nhật nhật ký")),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
