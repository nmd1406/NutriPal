import 'package:flutter/material.dart';
import 'package:nutripal/models/profile.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

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
            ...ActivityLevel.values.map((activity) {
              final isSelected = profile.activityLevel == activity;
              return GestureDetector(
                onTap: () => viewModel.updateActivityLevel(activity.value),
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
                        activity.icon,
                        size: 32,
                        color: isSelected ? primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey[800],
                              ),
                            ),
                            Text(
                              activity.description,
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
