import 'package:flutter/material.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

class StudentActionCard extends StatelessWidget {
  const StudentActionCard({
    super.key,
    required this.onPressed,
    required this.quiz,
  });

  final void Function() onPressed;
  final QuizModel quiz;

  @override
  Widget build(BuildContext context) {
    final (title, icon, showButton) = switch (quiz.state) {
      QuizState.upcoming => (
        'Quiz Starting Soon',
        Icons.lock_clock_outlined,
        false,
      ),
      QuizState.available => (
        'Ready to Start?',
        null,
        true,
      ),
      QuizState.closed => (
        'Quiz Closed',
        Icons.event_busy_rounded,
        false,
      ),
      _ => (
        'Access Restricted',
        Icons.lock_outline_rounded,
        false,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLightActive),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: quiz.state == QuizState.closed
                  ? AppColors.secondary
                  : AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 16),
          ],

          Text(
            title,
            style: AppStyles.mobileBodyLargeSb.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),

          _buildContextualDescription(),

          if (showButton) ...[
            const SizedBox(height: 24),
            AppButton(
              model: AppButtonStyleModel(
                label: 'Start Quiz Now',
                onPressed: onPressed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContextualDescription() {
    final defaultStyle = AppStyles.mobileBodyXsmallRg.copyWith(
      color: AppColors.secondary,
    );

    return Text.rich(
      TextSpan(
        style: defaultStyle,
        children: switch (quiz.state) {
          QuizState.upcoming => [
            const TextSpan(text: 'This quiz is scheduled to start on:\n'),
            TextSpan(
              text: quiz.formattedStartTime,
              style: const TextStyle(
                color: StatusColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          QuizState.available => [
            const TextSpan(
              text: 'Click the button below to begin your attempt.',
            ),
          ],
          QuizState.closed => [
            const TextSpan(
              text: 'The submission period for this quiz has ended.',
              style: TextStyle(
                color: StatusColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          _ => [
            const TextSpan(text: 'This quiz is currently unavailable.'),
          ],
        },
      ),
      textAlign: TextAlign.center,
    );
  }
}
