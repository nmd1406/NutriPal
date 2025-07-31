import 'package:flutter/material.dart';
import 'package:nutripal/views/widgets/water_progress_indicator.dart';

class WaterCard extends StatelessWidget {
  final double goal;
  final double currentIntake;

  const WaterCard({super.key, required this.goal, required this.currentIntake});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double progress = currentIntake / goal;

    return Container(
      width: double.infinity,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WaterProgressIndicator(
                  currentIntake: currentIntake,
                  goal: goal,
                  radius: 75,
                  progress: progress,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
