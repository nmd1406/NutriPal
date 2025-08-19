import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/food_record.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/widgets/date_selector.dart';
import 'package:nutripal/views/widgets/meal_diary_tile.dart';
import 'package:nutripal/views/widgets/water_diary_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({super.key});

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  late DateTime _selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedDate = ref.watch(diaryRecordViewModelProvider).selectedDate;
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    ref.read(diaryRecordViewModelProvider.notifier).changeDate(_selectedDate);
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    ref.read(diaryRecordViewModelProvider.notifier).changeDate(_selectedDate);
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
      ref.read(diaryRecordViewModelProvider.notifier).changeDate(_selectedDate);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
        action: SnackBarAction(
          label: "Reload",
          onPressed: () {
            ref.read(diaryRecordViewModelProvider.notifier).clearError();
            ref.read(diaryRecordViewModelProvider.notifier).refreshData();
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final tdee = ref.watch(tdeeProvider).round();

    final diaryTrackingState = ref.watch(diaryRecordViewModelProvider);

    if (diaryTrackingState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackbar(diaryTrackingState.errorMessage!);
      });
    }

    final int totalDailyCalories = diaryTrackingState
        .recordsByDate
        .totalDailyCalories
        .round();
    bool isLoading = diaryTrackingState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nhật ký",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
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
            _buildContent(tdee, totalDailyCalories, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(int tdee, int totalDailyCalories, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        children: [
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
                  const Text(
                    "Lượng calo còn lại",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                      const Text("-", style: TextStyle(fontSize: 32)),
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
                      const Text("=", style: TextStyle(fontSize: 26)),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ],
      ),
    );
  }
}
