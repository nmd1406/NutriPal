import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/splash_screen.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(profileProvider.notifier);
    final profileState = ref.watch(profileProvider);

    // Cache theme values
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        title: Text(
          "Thông tin cơ bản",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ),
      body: profileState.when(
        data: (profile) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Để tính toán chính xác nhu cầu dinh dưỡng, chúng tôi cần một số thông tin cơ bản về bạn",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giới tính",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.updateGender("male"),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: profile.gender == "male"
                                    ? primaryColor.withValues(alpha: 0.1)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: profile.gender == "male"
                                      ? primaryColor
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.male,
                                    size: 26,
                                    color: profile.gender == "male"
                                        ? primaryColor
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Nam",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: profile.gender == "male"
                                          ? primaryColor
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.updateGender("female"),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: profile.gender == "female"
                                    ? secondaryColor.withValues(alpha: 0.1)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: profile.gender == "female"
                                      ? secondaryColor
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.female,
                                    size: 26,
                                    color: profile.gender == "female"
                                        ? secondaryColor
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Nữ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: profile.gender == "female"
                                          ? secondaryColor
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        validator: viewModel.validateAge,
                        decoration: InputDecoration(
                          labelText: "Tuổi",
                          labelStyle: TextStyle(fontSize: 15),
                          prefixIcon: const Icon(Icons.cake_outlined, size: 26),
                          suffixText: "tuổi",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(width: 1.3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              validator: viewModel.validateHeight,
                              decoration: InputDecoration(
                                labelText: "Chiều cao",
                                labelStyle: TextStyle(fontSize: 15),
                                prefixIcon: const Icon(Icons.height, size: 26),
                                suffixText: "cm",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(width: 1.3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              validator: viewModel.validateWeight,
                              decoration: InputDecoration(
                                labelText: "Cân nặng",
                                labelStyle: TextStyle(fontSize: 15),
                                prefixIcon: const Icon(
                                  Icons.monitor_weight_outlined,
                                  size: 26,
                                ),
                                suffixText: "kg",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(width: 1.3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (profile.gender.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Vui lòng chọn giới tính'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            viewModel.updateAge(_ageController.text);
                            viewModel.updateHeight(_heightController.text);
                            viewModel.updateWeight(_weightController.text);
                            viewModel.submitProfile(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                          elevation: 8,
                          backgroundColor: primaryColor,
                        ),
                        child: Text(
                          "Tiếp tục",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const SplashScreen(),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 64),
              SizedBox(height: 16),
              Text(
                'Có lỗi xảy ra',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
