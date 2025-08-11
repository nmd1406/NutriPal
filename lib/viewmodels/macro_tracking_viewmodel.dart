import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/macro_record.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';

class MacroTrackingViewModel extends StateNotifier<MacroRecord> {
  final Ref ref;

  MacroTrackingViewModel(this.ref) : super(MacroRecord.empty()) {
    ref.listen<MealTrackingState>(mealTrackingViewModelProvider, (_, next) {
      _handleMealTrackingChange(next);
    });
  }

  void _handleMealTrackingChange(MealTrackingState mealTrackingState) {
    state = MacroRecord(
      proteinIntake: mealTrackingState.totalDailyProtein,
      fatIntake: mealTrackingState.totalDailyFat,
      carbIntake: mealTrackingState.totalDailyCarbs,
      date: DateTime.now(),
    );
  }
}

final macroTrackingViewModelProvider =
    StateNotifierProvider<MacroTrackingViewModel, MacroRecord>(
      (ref) => MacroTrackingViewModel(ref),
    );
