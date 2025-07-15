import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nutripal/models/profile.dart';
import 'package:nutripal/views/screens/welcome.dart';

class ProfileViewmodel extends StateNotifier<Profile> {
  ProfileViewmodel() : super(Profile.empty());

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateAge(String ageStr) {
    int age = int.tryParse(ageStr) ?? 0;
    state = state.copyWith(age: age);
  }

  void updateHeight(String heightStr) {
    double height = double.tryParse(heightStr) ?? 0.0;
    state = state.copyWith(height: height);
  }

  void updateWeight(String weightStr) {
    double weight = double.tryParse(weightStr) ?? 0.0;
    state = state.copyWith(weight: weight);
  }

  String? validateGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return "Vui lòng chọn giới tính";
    }

    return null;
  }

  String? validateAge(String? ageStr) {
    if (ageStr == null || ageStr.trim().isEmpty) {
      return "Vui lòng nhập tuổi";
    }
    int? age = int.tryParse(ageStr);
    if (age == null || age < 10 || age > 100) {
      return "Tuổi phải từ 10 đến 100";
    }
    return null;
  }

  String? validateHeight(String? heightStr) {
    if (heightStr == null || heightStr.trim().isEmpty) {
      return "Nhập chiều cao";
    }
    double? height = double.tryParse(heightStr);
    if (height == null || height < 100 || height > 250) {
      return "100-250cm";
    }
    return null;
  }

  String? validateWeight(String? weightStr) {
    if (weightStr == null || weightStr.trim().isEmpty) {
      return "Nhập cân nặng";
    }
    double? weight = double.tryParse(weightStr);
    if (weight == null || weight < 30 || weight > 200) {
      return "30-200kg";
    }
    return null;
  }

  void submitProfile(BuildContext context) {
    // Validation đã được handle ở UI level
    // Chỉ cần navigate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileViewmodel, Profile>(
  (ref) => ProfileViewmodel(),
);
