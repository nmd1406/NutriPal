import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MacrosCard extends StatelessWidget {
  final double baseCarb;
  final double carbIntake;
  final double baseFat;
  final double fatIntake;
  final double baseProtein;
  final double proteinIntake;

  const MacrosCard({
    super.key,
    required this.baseCarb,
    required this.carbIntake,
    required this.baseFat,
    required this.fatIntake,
    required this.baseProtein,
    required this.proteinIntake,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
                  label: "Carb",
                  baseValue: baseCarb,
                  intakeValue: carbIntake,
                  color: const Color.fromARGB(255, 44, 127, 47),
                ),
                _buildMacroIndicator(
                  label: "Fat",
                  baseValue: baseFat,
                  intakeValue: fatIntake,
                  color: Colors.deepPurple,
                ),
                _buildMacroIndicator(
                  label: "Protein",
                  baseValue: baseProtein,
                  intakeValue: proteinIntake,
                  color: Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroIndicator({
    required String label,
    required double baseValue,
    required double intakeValue,
    required Color color,
  }) {
    double remaining = baseValue - intakeValue;
    double progress = intakeValue / baseValue;
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
        const SizedBox(height: 12),
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
                intakeValue.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                "/${baseValue}g",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "${remaining}g còn lại",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
        ),
      ],
    );
  }
}
