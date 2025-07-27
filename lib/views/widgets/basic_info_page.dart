import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class BasicInfoPage extends StatefulWidget {
  final Profile profile;
  final ProfileViewModel viewModel;
  final GlobalKey<FormState> formKey;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  const BasicInfoPage({
    super.key,
    required this.profile,
    required this.viewModel,
    required this.formKey,
    required this.ageController,
    required this.heightController,
    required this.weightController,
  });

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  final Map<String, Timer> _timers = {};

  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  void _debounce(String key, VoidCallback action) {
    _timers[key]?.cancel();
    _timers[key] = Timer(const Duration(milliseconds: 500), () {
      action();
      _timers.remove(key);
    });
  }

  void _onAgeChanged(String age) {
    _debounce("age", () {
      if (age.trim().isNotEmpty) {
        widget.viewModel.updateAge(age);
      }
    });
  }

  void _onWeightChanged(String weight) {
    _debounce("weight", () {
      if (weight.trim().isNotEmpty) {
        widget.viewModel.updateWeight(weight);
      }
    });
  }

  void _onHeightChanged(String height) {
    _debounce("height", () {
      if (height.trim().isNotEmpty) {
        widget.viewModel.updateHeight(height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Text(
              "Để tính toán chính xác nhu cầu dinh dưỡng, chúng tôi cần một số thông tin cơ bản về bạn",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Giới tính",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.viewModel.updateGender("male"),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: widget.profile.gender == "male"
                                ? primaryColor.withValues(alpha: 0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.profile.gender == "male"
                                  ? primaryColor
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.male,
                                size: 26,
                                color: widget.profile.gender == "male"
                                    ? primaryColor
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Nam",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: widget.profile.gender == "male"
                                      ? primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.viewModel.updateGender("female"),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: widget.profile.gender == "female"
                                ? secondaryColor.withValues(alpha: 0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.profile.gender == "female"
                                  ? secondaryColor
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.female,
                                size: 26,
                                color: widget.profile.gender == "female"
                                    ? secondaryColor
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Nữ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: widget.profile.gender == "female"
                                      ? secondaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Form(
              key: widget.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: widget.ageController,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    validator: widget.viewModel.validateAge,
                    onChanged: _onAgeChanged,
                    decoration: InputDecoration(
                      labelText: "Tuổi",
                      labelStyle: TextStyle(fontSize: 15),
                      prefixIcon: const Icon(Icons.cake_outlined, size: 26),
                      suffixText: "tuổi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(width: 1.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: widget.heightController,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          validator: widget.viewModel.validateHeight,
                          onChanged: _onHeightChanged,
                          decoration: InputDecoration(
                            labelText: "Chiều cao",
                            labelStyle: TextStyle(fontSize: 15),
                            prefixIcon: const Icon(Icons.height, size: 26),
                            suffixText: "cm",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(width: 1.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: widget.weightController,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          validator: widget.viewModel.validateWeight,
                          onChanged: _onWeightChanged,
                          decoration: InputDecoration(
                            labelText: "Cân nặng",
                            labelStyle: TextStyle(fontSize: 15),
                            prefixIcon: const Icon(
                              Icons.monitor_weight_outlined,
                              size: 26,
                            ),
                            suffixText: "kg",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(width: 1.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
