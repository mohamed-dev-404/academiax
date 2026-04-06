import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class WrittenAnswer extends StatelessWidget {
  final String? answer;

  const WrittenAnswer({super.key, this.answer});

  @override
  Widget build(BuildContext context) {
    final bool hasAnswer = answer != null && answer!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Text(
        hasAnswer ? answer! : 'No answer provided by the student.',
        style: AppStyles.mobileBodySmallRg.copyWith(
          color: hasAnswer ? AppColors.primaryDarker : AppColors.whiteDark,
          fontStyle: hasAnswer ? FontStyle.normal : FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}
