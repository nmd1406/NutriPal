import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

const List<Map<String, dynamic>> goals = [
  {
    'value': 'lose',
    'title': 'Giảm cân',
    'icon': Icons.trending_down,
    'color': Colors.red,
  },
  {
    'value': 'maintain',
    'title': 'Duy trì cân nặng',
    'icon': Icons.balance,
    'color': Colors.blue,
  },
  {
    'value': 'gain',
    'title': 'Tăng cân',
    'icon': Icons.trending_up,
    'color': Colors.green,
  },
];

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
        widget.profile.goal == "gain" || widget.profile.goal == "lose";
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
            ...goals.map((goal) {
              final isSelected = widget.profile.goal == goal["value"] as String;
              return GestureDetector(
                onTap: () {
                  widget.viewModel.updateGoal(goal["value"] as String);
                  if (needsTargetWeight) {
                    widget.targetWeightController.clear();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (goal["color"] as Color).withValues(alpha: 0.2)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (goal["color"] as Color)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        goal["icon"] as IconData,
                        size: 32,
                        color: isSelected
                            ? goal["color"] as Color
                            : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        goal["title"] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? goal["color"] as Color
                              : Colors.grey[800],
                        ),
                      ),
                      isSelected ? const Spacer() : const SizedBox.shrink(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_outline,
                          size: 24,
                          color: goal["color"] as Color,
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
                      helperText: widget.profile.goal == "lose"
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
