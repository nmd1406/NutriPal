import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutripal/models/auth_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authState => _auth.authStateChanges();

  Future<AuthUser?> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final newUser = AuthUser(
          uid: credential.user!.uid,
          username: username,
          email: email,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection("users")
            .doc(newUser.uid)
            .set(newUser.toJson());

        return newUser;
      }
    } catch (e) {
      _handleAuthException(e);
    }

    return null;
  }

  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await getUserData(credential.user!.uid);
      }
    } catch (e) {
      _handleAuthException(e);
    }

    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateUserData({
    required String uid,
    String? username,
    String? imageUrl,
  }) async {
    try {
      final Map<String, dynamic> updatedProfileData = {
        "updatedAt": DateTime.now(),
      };

      if (username != null) {
        updatedProfileData["username"] = username;
      }

      if (imageUrl != null) {
        updatedProfileData["imageUrl"] = imageUrl;
      }

      await _firestore.collection("users").doc(uid).update(updatedProfileData);
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  Future<AuthUser?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        return AuthUser.fromJson(doc.data()!);
      }
    } catch (e) {
      throw Exception("Failed to get user data: $e");
    }
    return null;
  }

  Future<bool> hasProfile(String uid) async {
    try {
      final doc = await _firestore.collection("profiles").doc(uid).get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  void _handleAuthException(dynamic e) {
    String message;
    String errorMessage = e.toString().toLowerCase();

    if (errorMessage.contains('user-not-found') ||
        errorMessage.contains('no user record')) {
      message = 'Email không tồn tại';
    } else if (errorMessage.contains('wrong-password') ||
        errorMessage.contains('incorrect') ||
        errorMessage.contains('invalid-credential')) {
      message = 'Mật khẩu không đúng';
    } else if (errorMessage.contains('email-already-in-use')) {
      message = 'Email đã được sử dụng';
    } else if (errorMessage.contains('weak-password')) {
      message = 'Mật khẩu quá yếu';
    } else if (errorMessage.contains('invalid-email') ||
        errorMessage.contains('malformed')) {
      message = 'Email không hợp lệ';
    } else {
      message = 'Đã xảy ra lỗi: ${e.toString()}';
    }

    throw Exception(message);
  }
}
