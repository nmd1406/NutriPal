import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/services/auth_service.dart';
import 'package:nutripal/views/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends AsyncNotifier<Profile> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<void> updateUsername(String username) async {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
    state = AsyncValue.data(currentProfile.copyWith(username: username));
  }

  void updateImageUrl(String imageUrl) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    state = AsyncValue.data(currentProfile.copyWith(imageUrl: imageUrl));
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

  void updateActivityLevel(ActivityLevel activityLevel) {
    final currentProfile = state.valueOrNull ?? Profile.empty();
    state = AsyncValue.data(
      currentProfile.copyWith(activityLevel: activityLevel),
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

  String? validateUsername(String? username) {
    if (username == null ||
        username.trim().isEmpty ||
        username.trim().length < 6) {
      return "Tên người dùng phải có từ 6 kí tự trở lên";
    }
    return null;
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

  Future<File?> _compressImage(File imageFile) async {
    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        "${imageFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
        quality: 86,
        minWidth: 600,
        minHeight: 600,
      );

      if (compressedFile == null) {
        throw Exception("Failed to compress image");
      }

      return File(compressedFile.path);
    } catch (e) {
      throw Exception("Image compression failed: ${e.toString()}");
    }
  }

  Future<File?> pickImageFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    return picked != null ? File(picked.path) : null;
  }

  Future<File?> pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }

  Future<String?> uploadImage(File image) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }
    final compressedFile = await _compressImage(image);
    if (compressedFile == null) {
      throw Exception("Failed to compress image");
    }

    String fileName = "${DateTime.now().millisecondsSinceEpoch}";
    final storageRef = _storage.ref().child(
      "user_avatars/${user.uid}/$fileName",
    );
    final uploadTask = storageRef.putFile(compressedFile);
    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateProfileField({
    String? username,
    String? imageUrl,
    String? gender,
    int? age,
    double? height,
    double? weight,
    ActivityLevel? activityLevel,
    Goal? goal,
    double? targetWeight,
  }) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    final currentProfile = state.valueOrNull ?? Profile.empty();
    final updatedProfile = currentProfile.copyWith(
      username: username,
      imageUrl: imageUrl,
      gender: gender,
      age: age,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
      goal: goal,
      targetWeight: targetWeight,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _firestore
          .collection("profiles")
          .doc(user.uid)
          .update(updatedProfile.toJson());
      return updatedProfile;
    });
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

      Profile profileWithUid = currentProfile.copyWith(uid: user.uid);
      if (profileWithUid.username.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final fallbackUsername = prefs.getString("username");
        profileWithUid = profileWithUid.copyWith(username: fallbackUsername);
      }
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

final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, Profile>(() => ProfileViewModel());

final goalProvider = Provider<Goal>((ref) {
  final profileState = ref.watch(profileViewModelProvider);
  return profileState.when(
    data: (profile) => profile.goal,
    error: (_, _) => Goal.maintain,
    loading: () => Goal.maintain,
  );
});

final activityLevelProvider = Provider<ActivityLevel>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (profile) => profile.activityLevel,
    error: (_, _) => ActivityLevel.sedentary,
    loading: () => ActivityLevel.sedentary,
  );
});

final tdeeProvider = Provider<double>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (Profile profile) => profile.tdee,
    error: (_, _) => 0,
    loading: () => 0,
  );
});

final targetMacrosProvider = Provider<Map<String, double>>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (Profile profile) => profile.macroPercentagesTarget,
    error: (_, _) => {"carbs": 0, "fat": 0, "protein": 0},
    loading: () => {"carbs": 0, "fat": 0, "protein": 0},
  );
});

final recommendedDailyWaterProvider = Provider<double>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (Profile profile) => profile.recommendedDailyWater,
    error: (_, _) => 0,
    loading: () => 0,
  );
});

final currentWeightProvider = Provider<double>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (Profile profile) => profile.weight,
    error: (_, _) => 0,
    loading: () => 0,
  );
});

final genderProvider = Provider<String>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (profile) => profile.gender,
    error: (_, _) => "",
    loading: () => "",
  );
});

final ageProvider = Provider<int>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (profile) => profile.age,
    error: (_, _) => 0,
    loading: () => 0,
  );
});

final heightProvider = Provider<double>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (profile) => profile.height,
    error: (_, _) => 0.0,
    loading: () => 0.0,
  );
});

final usernameFromProfileProvider = Provider<String>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (profile) => profile.username,
    error: (_, _) => "",
    loading: () => "",
  );
});

final imageUrlFromProfileProvider = Provider<String>((ref) {
  final profileState = ref.watch(profileViewModelProvider);

  return profileState.when(
    data: (profile) => profile.imageUrl,
    error: (_, _) =>
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-da95b.appspot.com/o/avatar-default-svgrepo-com%20(1).png?alt=media&token=277d8bac-d5be-4ce8-a7a3-03bbe79906ae",
    loading: () =>
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-da95b.appspot.com/o/avatar-default-svgrepo-com%20(1).png?alt=media&token=277d8bac-d5be-4ce8-a7a3-03bbe79906ae",
  );
});
