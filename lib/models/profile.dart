import 'package:flutter/material.dart' show Colors, Color, IconData, Icons;

class Profile {
  final String uid;
  final String gender;
  final int age;
  final double height;
  final double weight;
  final ActivityLevel? activityLevel;
  final Goal? goal;
  final double targetWeight;

  const Profile({
    required this.uid,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    this.activityLevel,
    this.goal,
    this.targetWeight = 0.0,
  });

  Profile copyWith({
    String? uid,
    String? gender,
    int? age,
    double? height,
    double? weight,
    ActivityLevel? activityLevel,
    Goal? goal,
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
      activityLevel: ActivityLevel.fromValue(json['activityLevel'] as String),
      goal: Goal.fromValue(json['goal'] as String),
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
      activityLevel: null,
      goal: null,
      targetWeight: 0.0,
    );
  }

  bool get isValid {
    bool basicInfoValid =
        gender.isNotEmpty && age > 0 && height > 0 && weight > 0;
    bool activityValid = activityLevel != null;
    bool goalValid = goal != null;

    if (goal == Goal.gain || goal == Goal.lose) {
      goalValid = goalValid && targetWeight > 0;
    }

    return basicInfoValid && activityValid && goalValid;
  }

  bool get isEmpty {
    return gender.isEmpty &&
        age == 0 &&
        height == 0 &&
        weight == 0 &&
        activityLevel == null &&
        goal == null &&
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

  double get bmr {
    if (!isValid) {
      return 0;
    }

    if (gender.toLowerCase() == "male") {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    }
    return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
  }

  double get tdee {
    if (!isValid) {
      return 0;
    }

    double multiplier;
    switch (activityLevel!) {
      case ActivityLevel.sedentary:
        multiplier = 1.2;
        break;
      case ActivityLevel.light:
        multiplier = 1.375;
        break;
      case ActivityLevel.moderate:
        multiplier = 1.55;
        break;
      case ActivityLevel.active:
        multiplier = 1.725;
        break;
      case ActivityLevel.veryActive:
        multiplier = 1.9;
        break;
    }

    return _adjustedCalories(bmr * multiplier);
  }

  double _adjustedCalories(double tdee) {
    if (!isValid) {
      return 0;
    }

    switch (goal!) {
      case Goal.maintain:
        return tdee;
      case Goal.lose:
        return (tdee - _deficit).clamp(1200, tdee);
      case Goal.gain:
        return tdee + _surplus;
    }
  }

  double get _deficit {
    double weightDifference = weight - targetWeight;
    // 0.5kg/week
    double weeksToGoal = (weightDifference * 2).clamp(12, 52);
    // 1kg = 7700cal
    double dailyDeficit = (weightDifference * 7700) / (weeksToGoal * 7);

    return dailyDeficit.clamp(300, 750);
  }

  double get _surplus {
    double weightDifference = targetWeight - weight;
    // 0.33kg/week
    double weeksToGoal = (weightDifference * 3).clamp(16, 52);
    double dailySurplus = (weightDifference * 7700) / (weeksToGoal * 7);

    return dailySurplus.clamp(300, 500);
  }
}

enum BMICategory { underweight, normal, overweight, obeseI, obeseII }

enum ActivityLevel {
  sedentary(
    value: "sedentary",
    title: "Ít vận động",
    description: "Làm việc văn phòng, ít hoạt động thể chất",
    icon: Icons.airline_seat_recline_normal,
  ),
  light(
    value: "light",
    title: "Vận động nhẹ",
    description: "1-3 ngày/tuần tập thể dục nhẹ",
    icon: Icons.directions_walk,
  ),
  moderate(
    value: "moderate",
    title: "Vận động trung bình",
    description: "3-5 ngày/tuần tập thể dục vừa phải",
    icon: Icons.directions_run,
  ),
  active(
    value: "active",
    title: "Vận động nhiều",
    description: "6-7 ngày/tuần tập thể dục nặng",
    icon: Icons.fitness_center,
  ),
  veryActive(
    value: "veryActive",
    title: "Rất năng động",
    description: "Tập thể dục nặng hàng ngày + công việc thể chất",
    icon: Icons.sports_gymnastics,
  );

  const ActivityLevel({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String value;
  final String title;
  final String description;
  final IconData icon;

  static ActivityLevel? fromValue(String value) {
    for (ActivityLevel activityLevel in ActivityLevel.values) {
      if (activityLevel.value == value) {
        return activityLevel;
      }
    }
    return null;
  }
}

enum Goal {
  lose(
    value: "lose",
    title: "Giảm cân",
    icon: Icons.trending_down,
    color: Colors.red,
  ),
  maintain(
    value: "maintain",
    title: 'Duy trì cân nặng',
    icon: Icons.balance,
    color: Colors.blue,
  ),
  gain(
    value: "gain",
    title: 'Tăng cân',
    icon: Icons.trending_up,
    color: Colors.green,
  );

  const Goal({
    required this.value,
    required this.title,
    required this.icon,
    required this.color,
  });

  final String value;
  final String title;
  final IconData icon;
  final Color color;

  static Goal? fromValue(String value) {
    for (Goal goal in Goal.values) {
      if (goal.value == value) {
        return goal;
      }
    }
    return null;
  }

  bool get needsTargetWeight => this == Goal.lose || this == Goal.gain;
}
