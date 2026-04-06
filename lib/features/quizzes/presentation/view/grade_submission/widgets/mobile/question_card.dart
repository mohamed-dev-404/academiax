import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/grading_input_score_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/mcq_options_list.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/written_answer.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';

class QuestionCard extends StatelessWidget {
  final SubmissionDetailsModel question;
  final int index;
  final String submissionId;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.submissionId,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBgColor;
    Color borderColor;
    Color marksBadgeBg;
    Color marksColor;

    switch (question.state) {
      case QuestionUIState.correct:
        cardBgColor = StatusColors.green.withValues(alpha: 0.15);
        borderColor = StatusColors.green.withValues(alpha: 0.3);
        marksBadgeBg = StatusColors.green.withValues(alpha: 0.2);
        marksColor = StatusColors.green;
        break;
      case QuestionUIState.incorrect:
        cardBgColor = StatusColors.red.withValues(alpha: 0.1);
        borderColor = StatusColors.red.withValues(alpha: 0.2);
        marksBadgeBg = StatusColors.red.withValues(alpha: 0.15);
        marksColor = StatusColors.red;
        break;
      case QuestionUIState.unmarked:
        cardBgColor = StatusColors.orange.withValues(alpha: 0.1);
        borderColor = StatusColors.orange.withValues(alpha: 0.3);
        marksBadgeBg = StatusColors.orange.withValues(alpha: 0.2);
        marksColor = StatusColors.orange;
        break;
      default:
        cardBgColor = AppColors.whiteLight;
        borderColor = AppColors.secondaryLightActive.withValues(alpha: 0.5);
        marksBadgeBg = AppColors.secondaryLightActive.withValues(alpha: 0.2);
        marksColor = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Index, Type, Marks/Input)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUESTION ${index + 1}',
                      style: AppStyles.mobileBodyXsmallMd.copyWith(
                        color: AppColors.whiteDarkActive,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildTypeBadge(),
                  ],
                ),

                // Grading Input or Static Score inline as in the new image
                question.isWritten
                    ? BlocBuilder<GradingCubit, GradingState>(
                        builder: (context, state) {
                          final bool isSavingThis =
                              state is GradingQuestionSaving &&
                              state.savingQuestionId == question.id;
                          return GradingInputScoreField(
                            question: question,
                            isSaving: isSavingThis,
                            onSave: (score) {
                              context.read<GradingCubit>().gradeQuestion(
                                submissionId: submissionId,
                                questionId: question.id,
                                score: score,
                              );
                            },
                          );
                        },
                      )
                    : _buildStaticScoreBadge(marksBadgeBg, marksColor),
              ],
            ),

            const SizedBox(height: 24),

            // 2. Question Text
            Text(
              question.text,
              style: AppStyles.mobileLabelMediumMd.copyWith(
                color: AppColors.primaryDarkActive,
              ),
            ),

            const SizedBox(height: 20),

            // 3. Answer Body
            _buildAnswerBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    final bool isWritten = question.isWritten;
    final Color badgeColor = isWritten
        ? AppColors.primary
        : AppColors.secondary;
    final IconData badgeIcon = isWritten
        ? Icons.description_outlined
        : Icons.fact_check_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: 13,
            color: badgeColor,
          ),
          const SizedBox(width: 6),
          Text(
            question.uiTypeLabel.toUpperCase(),
            style: AppStyles.mobileBodyXsmallMd.copyWith(
              color: badgeColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticScoreBadge(Color badgeBg, Color marksColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        question.displayScore,
        style: AppStyles.mobileLabelMediumMd.copyWith(
          color: marksColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAnswerBody() {
    if (question.isWritten) {
      return WrittenAnswer(answer: question.writtenAnswer);
    } else {
      return McqOptionsList(options: question.options!);
    }
  }
}
