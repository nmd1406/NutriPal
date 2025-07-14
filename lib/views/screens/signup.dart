import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/profile_setup.dart';
import 'package:nutripal/views/screens/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _passwordShown = false;
  final _formKey = GlobalKey<FormState>();
  String _enteredUsername = "";
  String _enteredEmail = "";
  String _enteredPassword = "";

  bool _submit() {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      // FirebaseAuth later
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          "Tạo tài khoản",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                validator: (String? enteredUsername) {
                  if (enteredUsername == null ||
                      enteredUsername.trim().isEmpty ||
                      enteredUsername.trim().length < 6) {
                    return "Tên người dùng phải có từ 6 kí tự trở lên";
                  }
                  return null;
                },
                onSaved: (String? enteredUsername) {
                  _enteredUsername = enteredUsername!;
                },
                decoration: InputDecoration(
                  labelText: "Tên người dùng",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: const Icon(Icons.person_outline, size: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (String? enteredEmail) {
                  if (enteredEmail == null ||
                      enteredEmail.trim().isEmpty ||
                      !enteredEmail.contains("@")) {
                    return "Email không hợp lệ";
                  }
                  return null;
                },
                onSaved: (String? enteredEmail) {
                  _enteredEmail = enteredEmail!;
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: const Icon(Icons.email_outlined, size: 28),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: !_passwordShown,
                autocorrect: false,
                validator: (String? enteredPassword) {
                  if (enteredPassword == null ||
                      enteredPassword.trim().isEmpty ||
                      enteredPassword.trim().length < 6) {
                    return "Mật khẩu phải có từ 6 kí tự trở lên";
                  }
                  return null;
                },
                onSaved: (String? enteredPassword) {
                  _enteredPassword = enteredPassword!;
                },
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: const Icon(Icons.lock_outline, size: 28),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordShown = !_passwordShown;
                      });
                    },
                    icon: Icon(
                      _passwordShown
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: () {
                  if (_submit()) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileSetupScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "Đăng ký",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  text: "Đã có tài khoản? ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Đăng nhập",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
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
