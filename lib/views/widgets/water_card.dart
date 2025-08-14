import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/add_water_screen.dart';
import 'package:nutripal/views/widgets/water_progress_indicator.dart';

class WaterCard extends ConsumerWidget {
  const WaterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final recommendedDailyWater = ref.watch(recommendedDailyWaterProvider);

    final diaryTrackingState = ref.watch(diaryRecordViewModelProvider);
    final double currentIntake =
        diaryTrackingState.recordsByDate.totalWaterAmount;
    final double goal = recommendedDailyWater;
    final double progress = currentIntake / goal;

    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => AddWaterScreen())),
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
                "Nước",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: WaterProgressIndicator(
                  currentIntake: currentIntake,
                  goal: goal,
                  radius: 75,
                  progress: progress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
