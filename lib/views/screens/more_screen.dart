import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/auth_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/views/screens/health_indicator_screen.dart';
import 'package:nutripal/views/screens/nutrition_screen.dart';
import 'package:nutripal/views/screens/profile_screen.dart';
import 'package:nutripal/views/widgets/feature_list_tile.dart';
import 'package:nutripal/views/widgets/info_card.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  String _formatDouble(double value, [int precision = 2]) {
    return value.toStringAsFixed(precision).replaceAll(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.9),
                Theme.of(context).primaryColor.withValues(alpha: 0.7),
                Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: profileState.when(
          data: (profile) => Padding(
            padding: const EdgeInsetsGeometry.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  child: ClipOval(child: Image.network(profile.imageUrl)),
                ),
                const SizedBox(width: 12),
                Text(
                  profile.username,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
                ),
              ],
            ),
          ),
          error: (_, _) => const Text("Lỗi"),
          loading: () => const Text("Đang tải..."),
        ),
      ),
      body: Column(
        children: [
          profileState.when(
            data: (profile) {
              String height = "${_formatDouble(profile.height)}cm";
              String weight = "${_formatDouble(profile.weight)}kg";
              String age = "${profile.age}";
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 22,
                  children: [
                    InfoCard(info: height, label: "Chiều cao"),
                    InfoCard(info: weight, label: "Cân nặng"),
                    InfoCard(info: age, label: "Tuổi"),
                  ],
                ),
              );
            },
            error: (_, _) => const Text("Lỗi"),
            loading: () => const Text("Đang tải..."),
          ),

          FeatureListTile(
            icon: Icons.person,
            title: "Cá nhân",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
          FeatureListTile(
            icon: Icons.pie_chart_outline,
            title: "Dinh dưỡng",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NutritionScreen()),
            ),
          ),
          FeatureListTile(
            icon: Icons.health_and_safety_outlined,
            title: "Chỉ số sức khoẻ",
            subtitle: "BMI, TDEE & các chỉ số khác",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HealthIndicatorScreen(),
              ),
            ),
          ),
          FeatureListTile(
            icon: Icons.login_outlined,
            title: "Đăng xuất",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Đăng xuất"),
                  content: const Text("Bạn chắc chắn muốn đăng xuất?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        authViewModel.logout();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Có"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Không"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
