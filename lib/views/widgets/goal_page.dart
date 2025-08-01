import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class GoalPage extends StatefulWidget {
  final Profile profile;
  final ProfileViewModel viewModel;
  final TextEditingController targetWeightController;
  final GlobalKey<FormState> targetFormKey;

  const GoalPage({
    super.key,
    required this.profile,
    required this.viewModel,
    required this.targetWeightController,
    required this.targetFormKey,
  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTargetWeightChanged(String value) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        widget.viewModel.updateTargetWeight(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final needsTargetWeight =
        widget.profile.goal == Goal.gain || widget.profile.goal == Goal.lose;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Text(
              "Mục tiêu của bạn là gì?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ...Goal.values.map((goal) {
              final isSelected = widget.profile.goal == goal;
              return GestureDetector(
                onTap: () {
                  widget.viewModel.updateGoal(goal.value);
                  if (needsTargetWeight) {
                    widget.targetWeightController.clear();
                  } else {
                    widget.viewModel.updateTargetWeight("0.0");
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
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
                        color: isSelected ? goal.color : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        goal.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? goal.color : Colors.grey[800],
                        ),
                      ),
                      isSelected ? const Spacer() : const SizedBox.shrink(),
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
            if (needsTargetWeight) ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: widget.targetFormKey,
                  child: TextFormField(
                    controller: widget.targetWeightController,
                    keyboardType: TextInputType.number,
                    validator: widget.viewModel.validateTargetWeight,
                    onChanged: _onTargetWeightChanged,
                    decoration: InputDecoration(
                      labelText: "Cân nặng mục tiêu",
                      labelStyle: TextStyle(fontSize: 15),
                      prefixIcon: const Icon(Icons.track_changes, size: 28),
                      suffixText: "kg",
                      suffixStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 2),
                      ),
                      helperText: widget.profile.goal == Goal.lose
                          ? "Nhập cân nặng mà bạn muốn giảm"
                          : "Nhập cân nặng mà bạn muốn tăng",
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
