class Profile {
  final String uid;
  final String gender;
  final int age;
  final double height;
  final double weight;

  const Profile({
    required this.uid,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  Profile copyWith({
    String? uid,
    String? gender,
    int? age,
    double? height,
    double? weight,
  }) {
    return Profile(
      uid: uid ?? this.uid,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
    );
  }

  static Profile empty() {
    return Profile(uid: "", gender: "", age: 0, height: 0, weight: 0);
  }

  bool get isValid {
    return gender.isNotEmpty && age > 0 && height > 0 && weight > 0;
  }

  bool get isEmpty {
    return gender.isEmpty && age == 0 && height == 0 && weight == 0;
  }

  // business logics
}
