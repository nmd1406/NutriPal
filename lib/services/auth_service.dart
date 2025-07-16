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
    } on FirebaseAuthException catch (e) {
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
    } on FirebaseAuthException catch (e) {
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

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email không tồn tại';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'invalid-email':
        return 'Email không hợp lệ';
      default:
        return 'Đã xảy ra lỗi: ${e.message}';
    }
  }
}
