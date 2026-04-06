import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';

/// Info card shown for auto-graded MCQ/TF questions in the web grading panel.
///
/// Displays whether the answer was correct/wrong, the earned points,
/// and a note about automatic grading.
class AutoGradeInfoCard extends StatelessWidget {
  final SubmissionDetailsModel question;

  const AutoGradeInfoCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final bool correct = question.isCorrect ?? false;
    final color = correct ? StatusColors.green : StatusColors.red;
    final icon =
        correct ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final label = correct ? 'Correct Answer' : 'Wrong Answer';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppStyles.webAgBodyBold.copyWith(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Auto-graded: ${question.earnedPoints} / ${question.points} pts',
            style: AppStyles.webAgBodyRegular.copyWith(
              fontSize: 12,
              color: AppColors.primaryDarkActive,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'MCQ and True/False questions are graded automatically.',
            style: AppStyles.webAgBodyRegular.copyWith(
              fontSize: 11,
              color: AppColors.whiteDarkActive,
            ),
          ),
        ],
      ),
    );
  }
}
