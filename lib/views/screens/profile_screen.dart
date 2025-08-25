import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/change_goal_screen.dart';
import 'package:nutripal/views/screens/change_password_screen.dart';
import 'package:nutripal/views/screens/change_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cá nhân",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChangeProfileScreen(),
              ),
            ),
            title: Text("Thay đổi thông tin cá nhân"),
          ),
          const Divider(),
          ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ChangeGoalScreen()),
            ),
            title: Text("Thay đổi mục tiêu"),
          ),
          const Divider(),
          ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            ),
            title: Text("Đổi mật khẩu"),
          ),
        ],
      ),
    );
  }
}
