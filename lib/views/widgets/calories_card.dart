import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesCard extends ConsumerWidget {
  const CaloriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final profileState = ref.watch(profileProvider);

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
        child: profileState.when(
          data: (Profile profile) {
            final mealTrackingState = ref.watch(mealTrackingViewModelProvider);
            int food = mealTrackingState.totalDailyCalories.round();
            int baseGoal = profile.tdee.round();
            int remaining = baseGoal - food;
            double progress = food / baseGoal;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Calories",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Còn lại = Mục tiêu - Thức ăn",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularPercentIndicator(
                      radius: 69,
                      lineWidth: 11,
                      animation: true,
                      percent: progress.clamp(0, 1.0),
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Colors.orange,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => RadialGradient(
                              colors: <Color>[
                                primaryColor,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              radius: 2,
                              tileMode: TileMode.clamp,
                              center: Alignment.center,
                            ).createShader(bounds),
                            child: Text(
                              remaining.toString(),
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            "Còn lại",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        _buildInfoItem(
                          label: "Mục tiêu",
                          value: baseGoal.toString(),
                          icon: Icons.flag,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoItem(
                          label: "Thức ăn",
                          value: food.toString(),
                          icon: Icons.restaurant,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          error: (_, _) => const Text("Có lỗi..."),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            Text(
              value,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
