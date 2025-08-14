import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/macro_record.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';

class MacroTrackingViewModel extends StateNotifier<MacroRecord> {
  final Ref ref;

  MacroTrackingViewModel(this.ref) : super(MacroRecord.empty()) {
    ref.listen<DiaryRecordState>(diaryRecordViewModelProvider, (_, next) {
      _handleMealTrackingChange(next);
    });
  }

  void _handleMealTrackingChange(DiaryRecordState diaryRecordState) {
    final recordsByDate = diaryRecordState.recordsByDate;
    state = MacroRecord(
      proteinIntake: recordsByDate.totalDailyProtein,
      fatIntake: recordsByDate.totalDailyFat,
      carbIntake: recordsByDate.totalDailyCarbs,
    );
  }
}

final macroTrackingViewModelProvider =
    StateNotifierProvider<MacroTrackingViewModel, MacroRecord>(
      (ref) => MacroTrackingViewModel(ref),
    );
