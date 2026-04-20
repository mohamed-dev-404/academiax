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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryLightActive.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasAnswer ? answer! : 'No answer provided by the student.',
              style: AppStyles.mobileBodyMediumRg.copyWith(
                color: hasAnswer
                    ? AppColors.primaryDarker
                    : AppColors.whiteDarkActive,
                fontStyle: hasAnswer ? FontStyle.normal : FontStyle.italic,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
