import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/utils/manage_questions_ui_utils.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

class WebActionSidebar extends StatelessWidget {
  final ManageQuestionsArgs args;
  final List<EditableQuestionModel> questions;
  final void Function(String type) onAddQuestionType;

  const WebActionSidebar({
    super.key,
    required this.args,
    required this.questions,
    required this.onAddQuestionType,
  });

  void _onSaveChanges(BuildContext context) {
    if (questions.isEmpty) {
      AppSnackBar.error(context, 'Please add at least one question.');
      return;
    }

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q.text.isEmpty) {
        AppSnackBar.error(context, 'Question ${i + 1} is missing its text.');
        return;
      }
      if (q.questionType == ApiValues.mcq) {
        if (q.options.length < 2) {
          AppSnackBar.error(
            context,
            'Question ${i + 1} needs at least 2 options.',
          );
          return;
        }

        final hasCorrect = q.options.any((o) => o.isCorrect);
        if (!hasCorrect) {
          AppSnackBar.error(
            context,
            'Question ${i + 1} needs a correct option chosen.',
          );
          return;
        }

        for (var opt in q.options) {
          if (opt.text.isEmpty) {
            AppSnackBar.error(
              context,
              'Question ${i + 1} has an empty option.',
            );
            return;
          }
        }
      }
    }

    context.read<ManageQuizCubit>().submitQuestions(questions);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth(context);
    final paddingVal = screenWidth < 900 ? 16.0 : 24.0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppColors.whiteHover, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Section (Quiz Info) ───
          Container(
            padding: EdgeInsets.all(paddingVal),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(5),
              border: const Border(
                bottom: BorderSide(color: AppColors.whiteHover, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModeBadge(),
                const SizedBox(height: 16),
                Text(
                  args.quizTitle,
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ManageQuestionsUiUtils.getHeaderTitle(args.mode),
                  style: AppStyles.mobileBodySmallMd.copyWith(
                    color: AppColors.whiteDarkActive,
                  ),
                ),
              ],
            ),
          ),

          // ─── Action Palette ───
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(paddingVal),
              children: [
                Text(
                  'Add Question',
                  style: AppStyles.mobileBodySmallSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaletteOption(
                  icon: Icons.checklist_rounded,
                  label: 'Multiple Choice',
                  onTap: () => onAddQuestionType(ApiValues.mcq),
                ),
                const SizedBox(height: 12),
                _buildPaletteOption(
                  icon: Icons.toggle_on_outlined,
                  label: 'True / False',
                  onTap: () => onAddQuestionType(ApiValues.trueFalse),
                ),
                const SizedBox(height: 12),
                _buildPaletteOption(
                  icon: Icons.edit_note_rounded,
                  label: 'Written',
                  onTap: () => onAddQuestionType(ApiValues.written),
                ),
              ],
            ),
          ),

          // ─── Save Button Area ───
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.whiteHover, width: 1),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _onSaveChanges(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  args.mode == QuizMode.draft
                      ? 'Save Questions'
                      : 'Save Changes',
                  style: AppStyles.mobileBodySmallSb.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeBadge() {
    final badgeColor = ManageQuestionsUiUtils.getBadgeColor(args.mode);
    final badgeLabel = ManageQuestionsUiUtils.getBadgeLabel(args.mode);

    final effectiveColor = args.mode == QuizMode.edit
        ? AppColors.primary
        : badgeColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: effectiveColor.withAlpha(100), width: 1),
      ),
      child: Text(
        badgeLabel,
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: effectiveColor,
        ),
      ),
    );
  }

  Widget _buildPaletteOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteHover, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppStyles.mobileBodySmallMd.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const Icon(
              Icons.add_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
