import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/login.dart';
import 'package:nutripal/views/screens/signup.dart';

List<Map<String, String>> _onboardingContent = [
  {
    "assetPath": "assets/images/onboarding/calories_tracking.jpg",
    "content":
        "Ghi lại mọi bữa ăn và theo dõi lượng calo, protein, carbs một cách đơn giản",
  },
  {
    "assetPath": "assets/images/onboarding/macro_tracking.jpg",
    "content":
        "Xem báo cáo chi tiết về macro, micro và đạt được mục tiêu sức khỏe của bạn",
  },
  {
    "assetPath": "assets/images/onboarding/healthy_food.jpg",
    "content": "Tạo một thói quen ăn uống lành mạnh",
  },
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        title: const Text(
          'Chào mừng tới NutriPal!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 500,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedPage = index;
                    });
                  },
                  itemCount: _onboardingContent.length,
                  itemBuilder: (context, index) => OnboardingContent(
                    assetPath: _onboardingContent[index]["assetPath"]!,
                    content: _onboardingContent[index]["content"]!,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  ),
                  child: const Text("Đăng ký"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  child: const Text("Đăng nhập"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.assetPath,
    required this.content,
  });

  final String assetPath;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(aspectRatio: 1, child: Image.asset(assetPath)),
        Text(content),
      ],
    );
  }
}
