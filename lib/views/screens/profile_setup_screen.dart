import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/splash_screen.dart';
import 'package:nutripal/views/widgets/activity_level_page.dart';
import 'package:nutripal/views/widgets/basic_info_page.dart';
import 'package:nutripal/views/widgets/goal_page.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final int _totalSteps = 3;
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _targetFormKey = GlobalKey<FormState>();
  final _targetWeightController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        ++_currentStep;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        --_currentStep;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceedFromCurrentStep() {
    final profile = ref.watch(profileProvider).valueOrNull;
    if (profile == null) {
      return false;
    }
    switch (_currentStep) {
      case 0:
        return profile.gender.isNotEmpty &&
            _ageController.text.isNotEmpty &&
            _heightController.text.isNotEmpty &&
            _weightController.text.isNotEmpty &&
            _basicInfoFormKey.currentState?.validate() == true;
      case 1:
        return profile.activityLevel.isNotEmpty;
      case 2:
        if (profile.goal.isEmpty) {
          return false;
        }
        if (profile.goal == "lose" || profile.goal == "gain") {
          return _targetWeightController.text.trim().isNotEmpty &&
              (_targetFormKey.currentState?.validate() ?? false);
        }
        return true;
      default:
        return false;
    }
  }

  void _handleNextStep() {
    final viewModel = ref.read(profileProvider.notifier);

    if (_currentStep == 0) {
      _nextStep();
    } else if (_currentStep == 1) {
      _nextStep();
    } else if (_currentStep == 2) {
      final profile = ref.read(profileProvider).valueOrNull;
      final needsTargetWeight =
          profile?.goal == "lose" || profile?.goal == "gain";

      if (needsTargetWeight) {
        if (_targetFormKey.currentState!.validate()) {
          viewModel.submitProfile(context);
        }
      } else {
        viewModel.submitProfile(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(profileProvider.notifier);
    final profileState = ref.watch(profileProvider);

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

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
        data: (profile) => Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
              child: Row(
                children: List.generate(
                  _totalSteps,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index < _totalSteps - 1 ? 8 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                },
                children: [
                  BasicInfoPage(
                    profile: profile,
                    viewModel: viewModel,
                    formKey: _basicInfoFormKey,
                    ageController: _ageController,
                    heightController: _heightController,
                    weightController: _weightController,
                  ),
                  ActivityLevelPage(profile: profile, viewModel: viewModel),
                  GoalPage(
                    profile: profile,
                    viewModel: viewModel,
                    targetWeightController: _targetWeightController,
                    targetFormKey: _targetFormKey,
                  ),
                ],
              ),
            ),
          ],
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
      bottomNavigationBar: profileState.when(
        data: (profile) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: _currentStep == 0 ? null : _previousStep,
                  icon: Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: _currentStep == 0 ? Colors.grey : primaryColor,
                    ),
                    foregroundColor: primaryColor,
                    minimumSize: const Size(0, 44),
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: _canProceedFromCurrentStep()
                        ? _handleNextStep
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 45),
                      elevation: 8,
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      _currentStep == _totalSteps - 1
                          ? "Hoàn thành"
                          : "Tiếp tục",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (_, _) => null,
        loading: () => null,
      ),
    );
  }
}
