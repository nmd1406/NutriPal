import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WaterProgressIndicator extends StatelessWidget {
  final double currentIntake;
  final double goal;
  final double radius;
  final double progress;

  const WaterProgressIndicator({
    super.key,
    required this.currentIntake,
    required this.goal,
    required this.radius,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: 16,
      animation: true,
      percent: progress.clamp(0.0, 1.0),
      backgroundColor: Colors.grey.shade300,
      progressColor: Color.fromARGB(255, 38, 124, 228),
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentIntake.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 38, 124, 228),
            ),
          ),
          Text(
            '/${goal.toStringAsFixed(0)} mL',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
