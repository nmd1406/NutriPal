import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';

class BMIState {
  final Profile? userProfile;
  final Profile? calculatedProfile;
  final bool isCalculating;

  BMIState({
    this.userProfile,
    this.calculatedProfile,
    this.isCalculating = false,
  });

  BMIState copyWith({
    Profile? userProfile,
    Profile? calculatedProfile,
    bool? isCalculating,
  }) {
    return BMIState(
      userProfile: userProfile ?? this.userProfile,
      calculatedProfile: calculatedProfile ?? this.calculatedProfile,
      isCalculating: isCalculating ?? this.isCalculating,
    );
  }

  Profile? get displayProfile => calculatedProfile ?? userProfile;
}

class BMIViewModel extends StateNotifier<BMIState> {
  BMIViewModel() : super(BMIState());

  void setUserProfile(Profile profile) {
    state = state.copyWith(userProfile: profile);
  }

  void calculateBMI(double height, double weight) {
    if (state.userProfile == null) {
      return;
    }

    final Profile calculatedProfile = Profile.calculateBMI(
      state.userProfile!,
      height,
      weight,
    );

    state = state.copyWith(
      calculatedProfile: calculatedProfile,
      isCalculating: false,
    );
  }

  void resetToUserBMI() {
    state = state.copyWith(calculatedProfile: null);
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
}

final bmiViewModelProvider = StateNotifierProvider<BMIViewModel, BMIState>(
  (ref) => BMIViewModel(),
);
