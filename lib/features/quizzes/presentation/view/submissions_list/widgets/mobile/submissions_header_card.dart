import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class SubmissionsHeaderCard extends StatelessWidget {
  const SubmissionsHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.secondaryLightActive),
      ),
      child: Column(
        children: [
          Lottie.asset(AppLottie.quizSubmissions),

          const SizedBox(height: 8),
          Text(
            'Submissions Overview',
            style: AppStyles.mobileTitleSmallSb
          ),
        ],
      ),
    );
  }
}
