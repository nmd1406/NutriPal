import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/meal_record.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';
import 'package:nutripal/views/screens/add_food_screen.dart';

class MealDiaryCard extends ConsumerWidget {
  final Meal meal;

  const MealDiaryCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealTrackingState = ref.watch(mealTrackingViewModelProvider);

    final mealRecords = mealTrackingState.getMealRecords(meal);
    final totalCalories = mealTrackingState.getTotalCaloriesForMeal(meal);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 2),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 3,
            ),
            child: Row(
              children: [
                Text(
                  meal.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${totalCalories.toStringAsFixed(1)} cal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          mealRecords.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mealRecords.length,
                  itemBuilder: (context, index) {
                    final MealRecord mealRecord = mealRecords[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mealRecord.food.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Khẩu phần: ${mealRecord.servingAmount}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${mealRecord.totalCalories.toStringAsFixed(1)} cal",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          mealRecords.isEmpty
              ? const SizedBox.shrink()
              : const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: TextButton(
              onPressed: () {
                ref.read(currentMealProvider.notifier).state = meal;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddFoodScreen(meal: meal),
                  ),
                );
              },
              child: Text("Thêm", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
