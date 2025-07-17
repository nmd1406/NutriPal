import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/auth_user.dart';
import 'package:nutripal/services/auth_service.dart';
import 'package:nutripal/views/screens/home_screen.dart';
import 'package:nutripal/views/screens/profile_setup_screen.dart';

class AuthViewModel extends AutoDisposeAsyncNotifier<AuthUser?> {
  final _authService = AuthService();

  @override
  FutureOr<AuthUser?> build() async {
    final user = _authService.currentUser;

    if (user != null) {
      return await _authService.getUserData(user.uid);
    }
    return null;
  }

  String? validateUsername(String? enteredUsername) {
    if (enteredUsername == null ||
        enteredUsername.trim().isEmpty ||
        enteredUsername.trim().length < 6) {
      return "Tên người dùng phải có từ 6 kí tự trở lên";
    }
    return null;
  }

  String? validateEmail(String? enteredEmail) {
    if (enteredEmail == null || enteredEmail.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(enteredEmail)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? enteredPassword) {
    if (enteredPassword == null ||
        enteredPassword.trim().isEmpty ||
        enteredPassword.trim().length < 6) {
      return "Mật khẩu phải có từ 6 kí tự trở lên";
    }
    return null;
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final user = await _authService.signup(
        username: username,
        email: email,
        password: password,
      );

      await Future.delayed(Duration(milliseconds: 120));
      if (user != null && context.mounted) {
        Navigator.of(context).pop();
      }
      return user;
    });
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final user = await _authService.login(email: email, password: password);
      await Future.delayed(Duration(milliseconds: 120));

      if (user != null && context.mounted) {
        Navigator.of(context).pop();
      }
      return user;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _authService.logout();
      return null;
    });
  }
}

final authViewModelProvider =
    AutoDisposeAsyncNotifierProvider<AuthViewModel, AuthUser?>(
      () => AuthViewModel(),
    );
