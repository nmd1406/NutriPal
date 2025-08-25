import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChangeGoalScreen extends ConsumerStatefulWidget {
  const ChangeGoalScreen({super.key});

  @override
  ConsumerState<ChangeGoalScreen> createState() => _ChangeGoalScreenState();
}

class _ChangeGoalScreenState extends ConsumerState<ChangeGoalScreen> {
  final TextEditingController _targetWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile({
    ActivityLevel? activityLevel,
    Goal? goal,
    double? targetWeight,
  }) async {
    try {
      await ref
          .read(profileViewModelProvider.notifier)
          .updateProfileField(
            activityLevel: activityLevel,
            goal: goal,
            targetWeight: targetWeight,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thay đổi mục tiêu",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: profileState.when(
        data: (Profile profile) {
          final needsTargetWeight = profile.goal.needsTargetWeight;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mức độ vận động hàng ngày",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...ActivityLevel.values.map((ActivityLevel activity) {
                    bool isSelected = profile.activityLevel == activity;
                    return GestureDetector(
                      onTap: () async {
                        await _updateProfile(activityLevel: activity);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
                              color: isSelected
                                  ? secondaryColor
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(height: 4),
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
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: secondaryColor,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  Text(
                    "Mục tiêu",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...Goal.values.map((Goal goal) {
                    bool isSelected = profile.goal == goal;
                    return GestureDetector(
                      onTap: () async {
                        await _updateProfile(goal: goal);

                        if (!goal.needsTargetWeight) {
                          _targetWeightController.clear();
                          await _updateProfile(targetWeight: 0.0);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? goal.color.withValues(alpha: 0.2)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? goal.color : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              goal.icon,
                              size: 32,
                              color: isSelected ? goal.color : Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                goal.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? goal.color
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: goal.color,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),

                  if (needsTargetWeight) ...[
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _targetWeightController,
                      keyboardType: TextInputType.number,
                      validator: ref
                          .read(profileViewModelProvider.notifier)
                          .validateTargetWeight,
                      decoration: InputDecoration(
                        labelText: "Cân nặng mục tiêu",
                        labelStyle: const TextStyle(fontSize: 15),
                        prefixIcon: const Icon(Icons.track_changes, size: 28),
                        suffixText: "kg",
                        suffixStyle: const TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 2),
                        ),
                        helperText: profile.goal == Goal.lose
                            ? "Nhập cân nặng mà bạn muốn giảm"
                            : "Nhập cân nặng mà bạn muốn tăng",
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final targetWeight =
                                double.tryParse(_targetWeightController.text) ??
                                0.0;
                            await _updateProfile(targetWeight: targetWeight);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cập nhật cân nặng mục tiêu",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => const Skeletonizer(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Skeleton loading widgets
                SizedBox(height: 200),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Có lỗi xảy ra: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(profileViewModelProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
