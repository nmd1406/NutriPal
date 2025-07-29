import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/splash_screen.dart';
import 'package:nutripal/views/widgets/tdee_card.dart';
import 'package:nutripal/views/widgets/tdee_goal_card.dart';

class TDEETab extends ConsumerStatefulWidget {
  const TDEETab({super.key});

  @override
  ConsumerState<TDEETab> createState() => _TDEETabState();
}

class _TDEETabState extends ConsumerState<TDEETab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _targetWeightController;

  @override
  void initState() {
    double targetWeight = ref.read(profileProvider).value?.targetWeight ?? 0.0;
    _targetWeightController = TextEditingController(
      text: targetWeight == 0.0 ? null : _formatDouble(targetWeight),
    );

    super.initState();
  }

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }

  String _formatDouble(double value, [int precision = 2]) {
    return value.toStringAsFixed(precision).replaceAll(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final profileState = ref.watch(profileProvider);
    final profileViewModel = ref.read(profileProvider.notifier);

    return SingleChildScrollView(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Chỉ số TDEE của bạn",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              const TDEECard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TDEEGoalCard(
                      title: "Giảm cân",
                      value: "2,079",
                      unit: "cal/ngày",
                      color: Colors.red[400]!,
                      icon: Icons.trending_down,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TDEEGoalCard(
                      title: "Tăng cân",
                      value: "3,179",
                      unit: "cal/ngày",
                      color: Colors.green[400]!,
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "Mức độ vận động hàng ngày",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black38,
                  fontWeight: FontWeight.w600,
                ),
              ),
              profileState.when(
                data: (Profile profile) {
                  final needsTargetWeight =
                      profile.goal == Goal.gain || profile.goal == Goal.lose;
                  return Column(
                    children: [
                      ...ActivityLevel.values.map((ActivityLevel activity) {
                        bool isSelected = profile.activityLevel == activity;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? secondaryColor.withValues(alpha: 0.16)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? secondaryColor
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  activity.icon,
                                  size: 32,
                                  color: secondaryColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? secondaryColor
                                              : Colors.grey[800],
                                        ),
                                      ),
                                      Text(
                                        activity.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? secondaryColor
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      Text(
                        "Mục tiêu",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black38,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 25),
                      ...Goal.values.map((Goal goal) {
                        bool isSelected = profile.goal == goal;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? goal.color.withValues(alpha: 0.2)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? goal.color
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  goal.icon,
                                  size: 32,
                                  color: isSelected ? goal.color : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  goal.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? goal.color
                                        : Colors.grey[800],
                                  ),
                                ),
                                isSelected
                                    ? const Spacer()
                                    : const SizedBox.shrink(),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 24,
                                    color: goal.color,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      if (!needsTargetWeight)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _targetWeightController,
                              keyboardType: TextInputType.number,
                              validator: profileViewModel.validateTargetWeight,
                              decoration: InputDecoration(
                                labelText: "Cân nặng mục tiêu",
                                labelStyle: TextStyle(fontSize: 15),
                                prefixIcon: const Icon(
                                  Icons.track_changes,
                                  size: 28,
                                ),
                                suffixText: "kg",
                                suffixStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(width: 2),
                                ),
                                helperText: profile.goal == Goal.lose
                                    ? "Nhập cân nặng mà bạn muốn giảm"
                                    : "Nhập cân nặng mà bạn muốn tăng",
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                        ),
                        child: Text(
                          "Tính TDEE",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (_, _) => const Text("Có lỗi xảy ra"),
                loading: () => const SplashScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
