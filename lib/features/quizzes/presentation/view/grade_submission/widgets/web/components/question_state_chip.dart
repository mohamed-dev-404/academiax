import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/utils/ui_state_mapper.dart';

/// Displays the grading state of a question as a compact chip.
///
/// Used in the web layout's top bar to show: CORRECT / INCORRECT / MARKED / PENDING.
/// Extracted as shared for potential reuse in mobile detail views.
class QuestionStateChip extends StatelessWidget {
  final StudentSubmissionModel question;

  const QuestionStateChip({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: question.state.chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: question.state.chipColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            question.state.chipIcon,
            color: question.state.chipColor,
            size: 13,
          ),
          const SizedBox(width: 6),
          Text(
            question.state.chipLabel,
            style: AppStyles.webAgBodyBold.copyWith(
              fontSize: 11,
              color: question.state.chipColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
