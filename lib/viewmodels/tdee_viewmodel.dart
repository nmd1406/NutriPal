import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class TDEEViewModel extends StateNotifier<Profile> {
  TDEEViewModel(this.ref) : super(Profile.empty());

  final Ref ref;

  void setProfile(Profile profile) {
    state = profile;
  }

  void updateActivityLevel(ActivityLevel activityLevel) {
    state = state.copyWith(activityLevel: activityLevel);
  }

  void updateGoal(Goal goal) {
    state = state.copyWith(goal: goal);
  }

  void updateTargetWeight(double targetWeight) {
    state = state.copyWith(targetWeight: targetWeight);
  }

  String? validateTargetWeight(String? targetWeightStr) {
    if (targetWeightStr == null || targetWeightStr.trim().isEmpty) {
      return "Nhập cân nặng mục tiêu";
    }
    double? targetWeight = double.tryParse(targetWeightStr);
    if (targetWeight == null || targetWeight < 30 || targetWeight > 200) {
      return "30-200kg";
    }

    final currentProfile = state;

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

  void calculateTDEE() {
    final ProfileViewModel profileViewModel = ref.read(
      profileViewModelProvider.notifier,
    );

    profileViewModel.updateActivityLevel(state.activityLevel!);
    profileViewModel.updateGoal(state.goal!.value);
    profileViewModel.updateTargetWeight(state.targetWeight.toString());
  }
}

final tdeeViewModelProvider = StateNotifierProvider<TDEEViewModel, Profile>(
  (ref) => TDEEViewModel(ref),
);
