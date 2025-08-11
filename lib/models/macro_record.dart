class MacroRecord {
  final double proteinIntake;
  final double fatIntake;
  final double carbIntake;
  final DateTime date;

  const MacroRecord({
    required this.proteinIntake,
    required this.fatIntake,
    required this.carbIntake,
    required this.date,
  });

  Map<String, double> getMacroPercentages(
    double targetProtein,
    double targetCarb,
    double targetFat,
  ) => {
    "protein": proteinIntake / targetProtein * 100,
    "carb": carbIntake / targetCarb * 100,
    "fat": fatIntake / targetFat * 100,
  };

  MacroRecord copyWith({
    double? proteinIntake,
    double? fatIntake,
    double? carbIntake,
    DateTime? date,
  }) {
    return MacroRecord(
      proteinIntake: proteinIntake ?? this.proteinIntake,
      fatIntake: fatIntake ?? this.fatIntake,
      carbIntake: carbIntake ?? this.carbIntake,
      date: date ?? this.date,
    );
  }

  static MacroRecord empty() {
    return MacroRecord(
      proteinIntake: 0,
      fatIntake: 0,
      carbIntake: 0,
      date: DateTime.now(),
    );
  }
}
