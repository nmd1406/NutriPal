import 'package:flutter/material.dart' show Colors, Color;

class Profile {
  final String uid;
  final String gender;
  final int age;
  final double height;
  final double weight;
  final String activityLevel;
  final String goal;
  final double targetWeight;

  const Profile({
    required this.uid,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    this.activityLevel = '',
    this.goal = '',
    this.targetWeight = 0.0,
  });

  Profile copyWith({
    String? uid,
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
    double? targetWeight,
  }) {
    return Profile(
      uid: uid ?? this.uid,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'goal': goal,
      'targetWeight': targetWeight,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      activityLevel: json['activityLevel'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Profile empty() {
    return Profile(
      uid: "",
      gender: "",
      age: 0,
      height: 0,
      weight: 0,
      activityLevel: "",
      goal: "",
      targetWeight: 0.0,
    );
  }

  bool get isValid {
    bool basicInfoValid =
        gender.isNotEmpty && age > 0 && height > 0 && weight > 0;
    bool activityValid = activityLevel.isNotEmpty;
    bool goalValid = goal.isNotEmpty;

    // If goal is gain or lose, target weight must be set
    if (goal == 'gain' || goal == 'lose') {
      goalValid = goalValid && targetWeight > 0;
    }

    return basicInfoValid && activityValid && goalValid;
  }

  bool get isEmpty {
    return gender.isEmpty &&
        age == 0 &&
        height == 0 &&
        weight == 0 &&
        activityLevel.isEmpty &&
        goal.isEmpty &&
        targetWeight == 0;
  }

  double get bmi {
    if (height <= 0 || weight <= 0) {
      return 0;
    }
    return weight / ((height / 100) * (height / 100));
  }

  BMICategory get bmiCategory {
    if (bmi < 18.5) {
      return BMICategory.underweight;
    }
    if (bmi < 25) {
      return BMICategory.normal;
    }
    if (bmi < 30) {
      return BMICategory.overweight;
    }
    if (bmi < 35) {
      return BMICategory.obeseI;
    }
    return BMICategory.obeseII;
  }

  String get bmiDescription {
    switch (bmiCategory) {
      case BMICategory.underweight:
        return "Thiếu cân";
      case BMICategory.normal:
        return "Bình thường";
      case BMICategory.overweight:
        return "Thừa cân";
      case BMICategory.obeseI:
        return "Béo phì độ I";
      case BMICategory.obeseII:
        return "Béo phì độ II";
    }
  }

  Color get bmiColor {
    switch (bmiCategory) {
      case BMICategory.underweight:
        return Colors.blue;
      case BMICategory.normal:
        return Colors.green;
      case BMICategory.overweight:
        return Colors.yellow.shade600;
      case BMICategory.obeseI:
        return Colors.orange;
      case BMICategory.obeseII:
        return Colors.red;
    }
  }

  double getBMIPosition(double barWidth) {
    final bmiValue = bmi;
    double position;

    if (bmiValue < 18.5) {
      position = (bmiValue / 18.5) * (barWidth * 0.2);
    } else if (bmiValue < 25) {
      position =
          (barWidth * 0.2) +
          ((bmiValue - 18.5) / (25 - 18.5)) * (barWidth * 0.2);
    } else if (bmiValue < 30) {
      position =
          (barWidth * 0.4) + ((bmiValue - 25) / (30 - 25)) * (barWidth * 0.2);
    } else if (bmiValue < 35) {
      position =
          (barWidth * 0.6) + ((bmiValue - 30) / (35 - 30)) * (barWidth * 0.2);
    } else {
      position = (barWidth * 0.8) + ((bmiValue - 35) / 10) * (barWidth * 0.2);
      if (position > barWidth - 10) {
        position = barWidth - 10;
      }
    }

    return position.clamp(0.0, barWidth - 10);
  }

  static Profile calculateBMI(
    Profile baseProfile,
    double height,
    double weight,
  ) {
    return baseProfile.copyWith(height: height, weight: weight);
  }
}

enum BMICategory { underweight, normal, overweight, obeseI, obeseII }
