import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/stats_row.dart';

class InstructorContextualBanner extends StatelessWidget {
  final QuizModel quiz;
  const InstructorContextualBanner({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return switch (quiz.state) {
      QuizState.scheduled ||
      QuizState.onGoing ||
      QuizState.completed => StatsRow(quiz: quiz),

      QuizState.draft => const _ContextualInfoBanner(
        type: BannerType.info,
        title: 'Draft Mode',
        message:
            'This quiz is in draft mode. Add questions to publish it and make it scheduled for students.',
      ),

      QuizState.lockedDraft => const _ContextualInfoBanner(
        type: BannerType.warning,
        title: 'Quiz Time Expired',
        message:
            'You cannot add questions because the start time has passed. Update start time and duration first to unlock.',
      ),

      _ => const SizedBox.shrink(),
    };
  }
}

// --- 2. Generic Banner Section (DRY Principle) ---
enum BannerType { info, warning }

class _ContextualInfoBanner extends StatelessWidget {
  final BannerType type;
  final String title;
  final String message;

  const _ContextualInfoBanner({
    required this.type,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // Logic to select colors/icons based on type
    final isWarning = type == BannerType.warning;
    final baseColor = isWarning ? StatusColors.red : StatusColors.orange;
    final bgColor = isWarning ? AppColors.redLight : StatusColors.orangeLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: baseColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning
                ? Icons.warning_amber_rounded
                : Icons.info_outline_rounded,
            color: isWarning ? StatusColors.red : StatusColors.orangeDark,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWarning) ...[
                  Text(
                    title,
                    style: AppStyles.mobileBodyLargeSb.copyWith(
                      color: AppColors.redDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: AppStyles.mobileBodySmallRg.copyWith(
                    color: isWarning ? AppColors.red : StatusColors.orangeDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
