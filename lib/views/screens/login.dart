import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text("Đăng nhập"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        child: Form(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Mật khẩu"),
              ),
              const SizedBox(height: 10),
              TextButton(onPressed: () {}, child: Text("Quên mật khẩu?")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text("Đăng nhập")),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Chưa có tài khoản? ",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Đăng ký",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
