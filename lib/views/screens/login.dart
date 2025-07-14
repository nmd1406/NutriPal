import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordShown = false;
  final _formKey = GlobalKey<FormState>();
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
          "Chào mừng quay trở lại",
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
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Quên mật khẩu?",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_submit()) {
                    // Navigate to main app hoặc home screen
                    print("Đăng nhập thành công!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "Đăng nhập",
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
                  text: "Chưa có tài khoản? ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Đăng ký",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
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
