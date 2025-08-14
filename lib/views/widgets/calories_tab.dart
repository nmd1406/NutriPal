import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
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

    final tdee = ref.watch(tdeeProvider);

    final theme = Theme.of(context);
    final breakfastColor = theme.primaryColor;
    final lunchColor = theme.colorScheme.secondary;
    final dinnerColor = theme.colorScheme.onPrimaryContainer;
    final snackColor = theme.colorScheme.tertiary;

    final diaryRecordState = ref.watch(diaryRecordViewModelProvider);
    final recordsByDate = diaryRecordState.recordsByDate;
    final totalCalories = recordsByDate.totalDailyCalories;
    final breakfastCalories = recordsByDate.breakfastCalories;
    final lunchCalories = recordsByDate.lunchCalories;
    final dinnerCalories = recordsByDate.dinnerCalories;
    final snackCalories = recordsByDate.snackCalories;
    final breakfastPercentage = recordsByDate.breakfastPercentage;
    final lunchPercentage = recordsByDate.lunchPercentage;
    final dinnerPercentage = recordsByDate.dinnerPercentage;
    final snackPercentage = recordsByDate.snackPercentage;

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
                      duration: Duration.zero,
                      curve: Curves.linear,
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
                        startDegreeOffset: 0,
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
                Text(
                  "${tdee.round()}",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
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
