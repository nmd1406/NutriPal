class AuthUser {
  final String uid;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  AuthUser copyWith({
    String? uid,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      uid: json["uid"] as String,
      email: json["email"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  AuthUser empty() {
    return AuthUser(
      uid: "",
      email: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
