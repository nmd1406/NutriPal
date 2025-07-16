import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/login_screen.dart';
import 'package:nutripal/views/screens/signup_screen.dart';

List<Map<String, String>> _onboardingContent = [
  {
    "assetPath": "assets/images/onboarding/start_tracking.jpg",
    "content":
        "Ghi lại mọi bữa ăn và theo dõi lượng calo, protein, carbs một cách đơn giản",
  },
  {
    "assetPath": "assets/images/onboarding/macro_tracking.jpg",
    "content": "Xem báo cáo chi tiết \n về macro, micro và calo",
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
  int _selectingPage = 0;

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
        title: Column(
          children: [
            const Text(
              'Chào mừng tới',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(173, 0, 0, 0),
              ),
            ),
            Text(
              "NutriPal",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
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
                      _selectingPage = index;
                    });
                  },
                  itemCount: _onboardingContent.length,
                  itemBuilder: (context, index) => OnboardingContent(
                    assetPath: _onboardingContent[index]["assetPath"]!,
                    content: _onboardingContent[index]["content"]!,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingContent.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: AnimatedDot(isActive: _selectingPage == index),
                  ),
                ),
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 52),
                  elevation: 8,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
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

              const SizedBox(height: 10),

              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 52),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
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
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(assetPath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
        ),
      ],
    );
  }
}

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 18 : 6,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
