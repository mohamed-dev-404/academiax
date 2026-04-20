import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/utils/ui_state_mapper.dart';

/// Info card shown for auto-graded MCQ/TF questions in the web grading panel.
///
/// Displays whether the answer was correct/wrong, the earned points,
/// and a note about automatic grading.
class AutoGradeInfoCard extends StatelessWidget {
  final StudentSubmissionModel question;

  const AutoGradeInfoCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: question.state.autoGradeFeedbackColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: question.state.autoGradeFeedbackColor.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Icon(
                  question.state.autoGradeFeedbackIcon,
                  color: question.state.autoGradeFeedbackColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  question.state.autoGradeFeedbackLabel,
                  style: AppStyles.webAgBodyBold.copyWith(
                    fontSize: 12,
                    color: question.state.autoGradeFeedbackColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Auto-graded: ${question.displayScore}',
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
