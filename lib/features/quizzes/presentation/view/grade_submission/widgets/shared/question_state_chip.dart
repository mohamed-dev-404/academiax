import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';

/// Displays the grading state of a question as a compact chip.
///
/// Used in the web layout's top bar to show: CORRECT / INCORRECT / MARKED / PENDING.
/// Extracted as shared for potential reuse in mobile detail views.
class QuestionStateChip extends StatelessWidget {
  final SubmissionDetailsModel question;

  const QuestionStateChip({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    final IconData icon;

    switch (question.state) {
      case QuestionUIState.correct:
        color = StatusColors.green;
        label = 'CORRECT';
        icon = Icons.check_circle_rounded;
        break;
      case QuestionUIState.incorrect:
        color = StatusColors.red;
        label = 'INCORRECT';
        icon = Icons.cancel_rounded;
        break;
      case QuestionUIState.marked:
        color = AppColors.primary;
        label = 'MARKED';
        icon = Icons.done_all_rounded;
        break;
      case QuestionUIState.unmarked:
        color = StatusColors.orange;
        label = 'PENDING';
        icon = Icons.schedule_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppStyles.webAgBodyBold.copyWith(
              fontSize: 11,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
