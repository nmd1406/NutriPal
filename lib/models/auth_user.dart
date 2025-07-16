class AuthUser {
  final String uid;
  final String username;
  final String email;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUser({
    required this.uid,
    required this.username,
    required this.email,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  AuthUser copyWith({
    String? uid,
    String? username,
    String? email,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      uid: json["uid"] as String,
      username: json["username"] as String,
      email: json["email"] as String,
      imageUrl: json["imageUrl"] as String?,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "imageUrl": imageUrl,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  AuthUser empty() {
    return AuthUser(
      uid: "",
      username: "",
      email: "",
      imageUrl: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
