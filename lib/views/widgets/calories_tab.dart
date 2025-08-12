import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class CaloriesTab extends ConsumerStatefulWidget {
  const CaloriesTab({super.key});

  @override
  ConsumerState<CaloriesTab> createState() => _CaloriesTabState();
}

class _CaloriesTabState extends ConsumerState<CaloriesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _formatPercentage(double value) {
    if (value.isNaN || value.isInfinite || value.isNegative) {
      return "0%";
    }

    return "${(value * 100).round()}%";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const double chartRadius = 90;
    const divider = Divider(thickness: 1);

    final profileState = ref.watch(profileProvider);

    final theme = Theme.of(context);
    final breakfastColor = theme.primaryColor;
    final lunchColor = theme.colorScheme.secondary;
    final dinnerColor = theme.colorScheme.onPrimaryContainer;
    final snackColor = theme.colorScheme.tertiary;

    final mealTrackingState = ref.watch(mealTrackingViewModelProvider);
    final totalCalories = mealTrackingState.totalDailyCalories;
    final breakfastCalories = mealTrackingState.breakfastCalories;
    final lunchCalories = mealTrackingState.lunchCalories;
    final dinnerCalories = mealTrackingState.dinnerCalories;
    final snackCalories = mealTrackingState.snackCalories;
    final breakfastPercentage = mealTrackingState.breakfastPercentage;
    final lunchPercentage = mealTrackingState.lunchPercentage;
    final dinnerPercentage = mealTrackingState.dinnerPercentage;
    final snackPercentage = mealTrackingState.snackPercentage;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 1),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          totalCalories <= 0
              ? const SizedBox(height: 10)
              : const SizedBox.shrink(),
          totalCalories <= 0
              ? Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                )
              : FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          _sectionData(
                            breakfastPercentage,
                            chartRadius,
                            breakfastColor,
                          ),
                          _sectionData(
                            lunchPercentage,
                            chartRadius,
                            lunchColor,
                          ),
                          _sectionData(
                            dinnerPercentage,
                            chartRadius,
                            dinnerColor,
                          ),
                          _sectionData(
                            snackPercentage,
                            chartRadius,
                            snackColor,
                          ),
                        ],
                        centerSpaceRadius: 0,
                        sectionsSpace: 4,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildMealLegend(
                  "Bữa sáng",
                  breakfastPercentage,
                  breakfastCalories,
                  breakfastColor,
                ),
              ),
              Expanded(
                child: _buildMealLegend(
                  "Bữa trưa",
                  lunchPercentage,
                  lunchCalories,
                  lunchColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildMealLegend(
                  "Bữa tối",
                  dinnerPercentage,
                  dinnerCalories,
                  dinnerColor,
                ),
              ),
              Expanded(
                child: _buildMealLegend(
                  "Bữa phụ",
                  snackPercentage,
                  snackCalories,
                  snackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          divider,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng calories"),
                Text("${totalCalories.round()}"),
              ],
            ),
          ),
          divider,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mục tiêu"),
                profileState.when(
                  data: (Profile profile) => Text(
                    "${profile.tdee.round()}",
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  error: (_, _) => const Text("Có lỗi..."),
                  loading: () => const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          divider,
        ],
      ),
    );
  }

  PieChartSectionData _sectionData(double value, double radius, Color color) =>
      PieChartSectionData(
        value: value,
        radius: radius,
        color: color,
        title: _formatPercentage(value),
        titlePositionPercentageOffset: 0.55,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  Widget _buildMealLegend(
    String name,
    double percent,
    double totalCalories,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 20, height: 20, color: color),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name),
            Text(
              "${_formatPercentage(percent)} (${totalCalories.round()} cal)",
            ),
          ],
        ),
      ],
    );
  }
}
