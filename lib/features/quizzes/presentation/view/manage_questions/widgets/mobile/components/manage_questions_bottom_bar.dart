import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

/// The sticky bottom navigation bar component for the Manage Questions screen.
///
/// Responsible for rendering the floating "Save Questions" or "Save Changes" button,
/// executing local UI validation on all questions, and finally delegating to the
/// [ManageQuizCubit] for submission.
class ManageQuestionsBottomBar extends StatelessWidget {
  final QuizMode mode;
  final List<EditableQuestionModel> questions;

  const ManageQuestionsBottomBar({
    super.key,
    required this.mode,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManageQuizCubit>();
    final label = mode == QuizMode.draft ? 'Save Questions' : 'Save Changes';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: questions.isEmpty ? null : () => _onSaveTapped(context, cubit),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: questions.isEmpty
                ? null
                : const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
            color: questions.isEmpty ? AppColors.whiteHover : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: questions.isNotEmpty
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.mobileBodySmallMd.copyWith(
              color: questions.isEmpty
                  ? AppColors.whiteDarkActive
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Evaluates local UI integrity checks before delegating API submission.
  void _onSaveTapped(BuildContext context, ManageQuizCubit cubit) {
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q.text.trim().isEmpty) {
        AppSnackBar.error(context, 'Question ${i + 1} is missing its text.');
        return;
      }
      if (q.isMcq || q.isTrueFalse) {
        final hasCorrect = q.options.any((o) => o.isCorrect);
        if (!hasCorrect) {
          AppSnackBar.error(
            context,
            'Question ${i + 1} needs a correct answer selected.',
          );
          return;
        }
        if (q.isMcq) {
          final emptyOpts = q.options.where((o) => o.text.trim().isEmpty);
          if (emptyOpts.isNotEmpty) {
            AppSnackBar.error(
              context,
              'Question ${i + 1} has empty option(s).',
            );
            return;
          }
        }
      }
    }

    cubit.submitQuestions(questions);
  }
}
