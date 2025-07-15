class Profile {
  final String gender;
  final int age;
  final double height;
  final double weight;

  const Profile({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  Profile copyWith({String? gender, int? age, double? height, double? weight}) {
    return Profile(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  static Profile empty() {
    return Profile(gender: '', age: 0, height: 0, weight: 0);
  }

  bool get isValid {
    return gender.isNotEmpty && age > 0 && height > 0 && weight > 0;
  }

  bool get isEmpty {
    return gender.isEmpty && age == 0 && height == 0 && weight == 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile &&
        other.gender == gender &&
        other.age == age &&
        other.height == height &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return gender.hashCode ^ age.hashCode ^ height.hashCode ^ weight.hashCode;
  }

  // business logics
}
