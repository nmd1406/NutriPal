import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/bmi_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/splash_screen.dart';
import 'package:nutripal/views/widgets/bmi_indicator.dart';

class BMITab extends ConsumerStatefulWidget {
  const BMITab({super.key});

  @override
  ConsumerState<BMITab> createState() => _BMITabState();
}

class _BMITabState extends ConsumerState<BMITab> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileProvider);
      profileState.whenData((Profile profile) {
        ref.read(bmiViewModelProvider.notifier).setUserProfile(profile);
        _heightController.text = _formatDouble(profile.height);
        _weightController.text = _formatDouble(profile.weight);
      });
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _formatDouble(double value, [int precision = 2]) {
    return value.toStringAsFixed(precision).replaceAll(RegExp(r'\.?0+$'), '');
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double? height = double.tryParse(_heightController.text) ?? 0.0;
      double? weight = double.tryParse(_weightController.text) ?? 0.0;
      ref.read(bmiViewModelProvider.notifier).calculateBMI(height, weight);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    final bmiState = ref.watch(bmiViewModelProvider);
    final bmiViewModel = ref.read(bmiViewModelProvider.notifier);
    final profileState = ref.watch(profileProvider);

    return profileState.when(
      data: (profile) =>
          _buildBMIContent(context, deviceSize, bmiState, bmiViewModel),
      loading: () => const SplashScreen(),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra khi tải dữ liệu',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIContent(
    BuildContext context,
    Size deviceSize,
    BMIState bmiState,
    BMIViewModel bmiViewModel,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 46),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Chỉ số BMI",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                height: deviceSize.height * 0.26,
                width: deviceSize.width * 0.7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.4),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 4,
                      offset: const Offset(-1, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        bmiState.displayProfile != null
                            ? _formatDouble(bmiState.displayProfile!.bmi, 1)
                            : "0.0",
                        style: TextStyle(
                          fontSize: 66,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      bmiState.displayProfile != null
                          ? BMIIndicator(profile: bmiState.displayProfile!)
                          : SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  "Đang tải...",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: bmiViewModel.validateHeight,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Chiều cao",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: Icon(
                    Icons.height,
                    size: 26,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  suffixStyle: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 16,
                  ),
                  suffixText: "cm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: bmiViewModel.validateWeight,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Cân nặng",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: Icon(
                    Icons.monitor_weight_outlined,
                    color: Theme.of(context).primaryColorDark,
                    size: 26,
                  ),
                  suffixText: "kg",
                  suffixStyle: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
                child: Text(
                  "Tính BMI",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
