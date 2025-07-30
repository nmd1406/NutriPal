import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nutripal/models/profile.dart';
import 'package:nutripal/services/auth_service.dart';
import 'package:nutripal/views/screens/welcome_screen.dart';

class ProfileViewModel extends AsyncNotifier<Profile> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  FutureOr<Profile> build() async {
    final user = _authService.currentUser;

    if (user != null) {
      try {
        final doc = await _firestore.collection("profiles").doc(user.uid).get();

        if (doc.exists) {
          return Profile.fromJson(doc.data()!);
        }
      } catch (e) {
        return Profile.empty();
      }
    }
    return Profile.empty();
  }

  void updateGender(String gender) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    state = AsyncValue.data(currentProfile.copyWith(gender: gender));
  }

  void updateAge(String ageStr) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    int age = int.tryParse(ageStr) ?? 0;
    state = AsyncValue.data(currentProfile.copyWith(age: age));
  }

  void updateHeight(String heightStr) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    double height = double.tryParse(heightStr) ?? 0.0;
    state = AsyncValue.data(currentProfile.copyWith(height: height));
  }

  void updateWeight(String weightStr) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    double weight = double.tryParse(weightStr) ?? 0.0;
    state = AsyncValue.data(currentProfile.copyWith(weight: weight));
  }

  void updateActivityLevel(String activityLevel) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    state = AsyncValue.data(
      currentProfile.copyWith(
        activityLevel: ActivityLevel.fromValue(activityLevel),
      ),
    );
  }

  void updateGoal(String goal) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    state = AsyncValue.data(
      currentProfile.copyWith(goal: Goal.fromValue(goal)),
    );
  }

  void updateTargetWeight(String targetWeightStr) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    double targetWeight = double.tryParse(targetWeightStr) ?? 0.0;
    state = AsyncValue.data(
      currentProfile.copyWith(targetWeight: targetWeight),
    );
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

  String? validateTargetWeight(String? targetWeightStr) {
    if (targetWeightStr == null || targetWeightStr.trim().isEmpty) {
      return "Nhập cân nặng mục tiêu";
    }
    double? targetWeight = double.tryParse(targetWeightStr);
    if (targetWeight == null || targetWeight < 30 || targetWeight > 200) {
      return "30-200kg";
    }

    final currentProfile = state.valueOrNull ?? Profile.empty();

    if (currentProfile.goal == Goal.gain &&
        targetWeight <= currentProfile.weight) {
      return "Cân nặng mục tiêu phải lớn hơn cân nặng hiện tại";
    }
    if (currentProfile.goal == Goal.lose &&
        targetWeight >= currentProfile.weight) {
      return "Cân nặng mục tiêu phải bé hơn cân nặng hiện tại";
    }
    return null;
  }

  Future<void> submitProfile(BuildContext context) async {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    if (!currentProfile.isValid) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final profileWithUid = currentProfile.copyWith(uid: user.uid);
      await _firestore
          .collection("profiles")
          .doc(profileWithUid.uid)
          .set(profileWithUid.toJson());

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
      return profileWithUid;
    });
  }
}

final profileProvider = AsyncNotifierProvider<ProfileViewModel, Profile>(
  () => ProfileViewModel(),
);
