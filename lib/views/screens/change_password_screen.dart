import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/auth_viewmodel.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showConfirmPassword = false;
  bool _showNewPassword = false;
  bool _showCurrentPassword = false;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      final viewModel = ref.read(changePasswordProvider.notifier);
      String? errorMessage = await viewModel.validateCurrentPassword(
        _currentPasswordController.text,
      );

      if (errorMessage != null && context.mounted) {
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _currentPasswordController.clear();

        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      viewModel.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Đổi mật khẩu thành công"),
          duration: Duration(seconds: 3),
        ),
      );

      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    final authViewModel = ref.read(authViewModelProvider.notifier);
    final changePasswordState = ref.watch(changePasswordProvider);

    ref.listen(changePasswordProvider, (previous, next) {
      if (next.hasError && mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString().replaceFirst("Exception: ", ""),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đổi mật khẩu",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                autocorrect: false,
                validator: authViewModel.validatePassword,
                decoration: InputDecoration(
                  hintText: "Mật khẩu hiện tại",
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                    icon: Icon(
                      _showCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                autocorrect: false,
                validator: authViewModel.validatePassword,
                decoration: InputDecoration(
                  hintText: "Mật khẩu mới",
                  helperText: "6 kí tự tối thiểu",
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                autocorrect: false,
                validator: (_) {
                  return authViewModel.validateConfirmPassword(
                    _newPasswordController.text.trim(),
                    _confirmPasswordController.text.trim(),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Xác nhận mật khẩu",
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () async {
                  await _submit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text(
                  "Thay đổi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              changePasswordState.when(
                data: (_) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error.toString().replaceFirst('Exception: ', ''),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
