import 'package:flutter/material.dart' show Colors, Color, IconData, Icons;

class Profile {
  final String uid;
  final String username;
  final String imageUrl;
  final String gender;
  final int age;
  final double height;
  final double weight;
  final ActivityLevel? activityLevel;
  final Goal? goal;
  final double targetWeight;

  const Profile({
    required this.uid,
    required this.username,
    required this.imageUrl,
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
    String? username,
    String? imageUrl,
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
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }

  @override
  String toString() => "$uid, $username, $goal, $activityLevel";

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'imageUrl': imageUrl,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel?.value,
      'goal': goal?.value,
      'targetWeight': targetWeight,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'] as String,
      username: json['username'] as String? ?? "",
      imageUrl:
          json['imageUrl'] as String? ??
          "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-da95b.appspot.com/o/avatar-default-svgrepo-com%20(1).png?alt=media&token=277d8bac-d5be-4ce8-a7a3-03bbe79906ae",
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
      username: "",
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-da95b.appspot.com/o/avatar-default-svgrepo-com%20(1).png?alt=media&token=277d8bac-d5be-4ce8-a7a3-03bbe79906ae",
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
        username.isNotEmpty &&
        gender.isNotEmpty &&
        age > 0 &&
        height > 0 &&
        weight > 0;
    bool activityValid = activityLevel != null;
    bool goalValid = goal != null;

    if (goal == Goal.gain || goal == Goal.lose) {
      goalValid = goalValid && targetWeight > 0;
    }

    return basicInfoValid && activityValid && goalValid;
  }

  bool get isEmpty {
    return username.isEmpty &&
        gender.isEmpty &&
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

  double get recommendedDailyWater {
    if (!isValid) return 2000; // Default 2L

    // Công thức chính: 30-35ml/kg
    double baseWater = weight * 32;

    // Điều chỉnh theo các yếu tố
    double multiplier = 1.0;

    // Giới tính
    multiplier *= gender.toLowerCase() == "male" ? 1.05 : 1.0;

    // Tuổi
    if (age < 30) {
      multiplier *= 1.05;
    } else if (age > 65) {
      multiplier *= 0.95;
    }

    // Hoạt động
    if (activityLevel != null) {
      switch (activityLevel!) {
        case ActivityLevel.sedentary:
          multiplier *= 1.0;
          break;
        case ActivityLevel.light:
          multiplier *= 1.1;
          break;
        case ActivityLevel.moderate:
          multiplier *= 1.2;
          break;
        case ActivityLevel.active:
          multiplier *= 1.3;
          break;
        case ActivityLevel.veryActive:
          multiplier *= 1.4;
          break;
      }
    }

    // BMI adjustment
    if (bmi > 25) {
      multiplier *= 1.1; // Người thừa cân cần nhiều nước hơn
    }

    double finalWater = baseWater * multiplier;

    // Làm tròn đến 250ml gần nhất
    return (finalWater / 250).round() * 250.0;
  }

  // Protein (g): 1.6 - 2.2g/kg
  double get targetProtein {
    if (!isValid) {
      return 0;
    }

    double proteinPerKg;
    switch (goal!) {
      case Goal.lose:
        proteinPerKg = 2.0;
        break;
      case Goal.maintain:
        proteinPerKg = 1.6;
        break;
      case Goal.gain:
        proteinPerKg = 1.8;
        break;
    }

    if (activityLevel == ActivityLevel.active ||
        activityLevel == ActivityLevel.veryActive) {
      proteinPerKg += 0.2;
    }

    return goal == Goal.maintain
        ? weight * proteinPerKg
        : targetWeight * proteinPerKg;
  }

  // Fat(g): 20 - 35% tổng calories
  double get targetFat {
    if (!isValid) {
      return 0;
    }

    double fatPercentage;
    switch (goal!) {
      case Goal.lose:
        fatPercentage = 0.25;
        break;
      case Goal.gain:
        fatPercentage = 0.3;
        break;
      case Goal.maintain:
        fatPercentage = 0.28;
        break;
    }

    // Fat: 9kcal/g
    return (tdee * fatPercentage) / 9;
  }

  double get _carbsCalories => 4;
  double get _proteinCalories => 4;
  double get _fatCalories => 9;

  // Phần còn lại sau protein và fat
  double get targetCarbs {
    if (!isValid) {
      return 0;
    }

    double proteinCalories = _proteinCalories * targetProtein;
    double fatCalories = _fatCalories * targetFat;
    double remainingCalories = tdee - proteinCalories - fatCalories;

    return remainingCalories / _carbsCalories;
  }

  Map<String, double> get macroPercentagesTarget {
    if (!isValid) {
      return {"protein": 0, "carbs": 0, "fat": 0};
    }

    double targetCalories = tdee;

    return {
      "protein": (targetProtein * _proteinCalories) / targetCalories * 100,
      "carbs": (targetCarbs * _carbsCalories) / targetCalories * 100,
      "fat": (targetFat * _fatCalories) / targetCalories * 100,
    };
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
