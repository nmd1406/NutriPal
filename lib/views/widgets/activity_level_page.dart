import 'package:flutter/material.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

const List<Map<String, dynamic>> activities = [
  {
    'value': 'sedentary',
    'title': 'Ít vận động',
    'description': 'Làm việc văn phòng, ít hoạt động thể chất',
    'icon': Icons.airline_seat_recline_normal,
  },
  {
    'value': 'light',
    'title': 'Vận động nhẹ',
    'description': '1-3 ngày/tuần tập thể dục nhẹ',
    'icon': Icons.directions_walk,
  },
  {
    'value': 'moderate',
    'title': 'Vận động trung bình',
    'description': '3-5 ngày/tuần tập thể dục vừa phải',
    'icon': Icons.directions_run,
  },
  {
    'value': 'active',
    'title': 'Vận động nhiều',
    'description': '6-7 ngày/tuần tập thể dục nặng',
    'icon': Icons.fitness_center,
  },
  {
    'value': 'very_active',
    'title': 'Rất năng động',
    'description': 'Tập thể dục nặng hàng ngày + công việc thể chất',
    'icon': Icons.sports_gymnastics,
  },
];

class ActivityLevelPage extends StatelessWidget {
  final ProfileViewModel viewModel;
  final Profile profile;
  const ActivityLevelPage({
    super.key,
    required this.viewModel,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Text(
              "Mức độ vận động hàng ngày của bạn như nào?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              "Điều này giúp chúng tôi tính toán lượng \n calo phù hợp",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 15),
            ...activities.map((activity) {
              final isSelected =
                  profile.activityLevel == activity["value"] as String;
              return GestureDetector(
                onTap: () =>
                    viewModel.updateActivityLevel(activity["value"] as String),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.2)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        activity["icon"] as IconData,
                        size: 32,
                        color: isSelected ? primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity["title"] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey[800],
                              ),
                            ),
                            Text(
                              activity["description"] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      isSelected
                          ? const SizedBox(width: 9)
                          : const SizedBox.shrink(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_outline_outlined,
                          size: 24,
                          color: primaryColor,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
