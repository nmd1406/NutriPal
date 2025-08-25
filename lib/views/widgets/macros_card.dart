import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/nutrition_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MacrosCard extends ConsumerWidget {
  const MacrosCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;

    final targetMacros = ref.watch(targetMacrosProvider);
    final diaryRecordState = ref.watch(diaryRecordViewModelProvider);
    final recordsByDate = diaryRecordState.recordsByDate;

    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => NutritionScreen(page: 1))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.4),
            width: 1,
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Macros",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroIndicator(
                    label: "Carbs",
                    goalValue: targetMacros["carbs"] ?? 0.0,
                    intakeValue: recordsByDate.totalDailyCarbs,
                    color: const Color.fromARGB(255, 44, 127, 47),
                  ),
                  _buildMacroIndicator(
                    label: "Fat",
                    goalValue: targetMacros["fat"] ?? 0.0,
                    intakeValue: recordsByDate.totalDailyFat,
                    color: Colors.deepPurple,
                  ),
                  _buildMacroIndicator(
                    label: "Protein",
                    goalValue: targetMacros["protein"] ?? 0.0,
                    intakeValue: recordsByDate.totalDailyProtein,
                    color: Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroIndicator({
    required String label,
    required double goalValue,
    required double intakeValue,
    required Color color,
  }) {
    double progress = intakeValue / goalValue;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        CircularPercentIndicator(
          radius: 47,
          percent: progress.clamp(0, 1.0),
          lineWidth: 11,
          animation: true,
          backgroundColor: Colors.grey.shade300,
          progressColor: color,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                intakeValue.toInt().toString(),
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                "/${goalValue.toInt()}g",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
