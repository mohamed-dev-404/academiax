import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/grading_input_score_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/auto_grade_info_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';

/// Right sidebar panel for the web grading layout.
///
/// Shows: total score summary card, grading input (for written questions)
/// or auto-grade info (for MCQ/TF), and an instructor note field.
class GradingActionPanel extends StatelessWidget {
  final SubmissionDetailsModel question;
  final String submissionId;
  final List<SubmissionDetailsModel> questions;

  const GradingActionPanel({
    super.key,
    required this.question,
    required this.submissionId,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final int gradedCount =
        questions.where((q) => q.isGraded || !q.isWritten).length;
    final int totalPoints = questions.fold(0, (sum, q) => sum + q.points);
    final int earnedPoints =
        questions.fold(0, (sum, q) => sum + q.earnedPoints);
    final double progressValue =
        totalPoints == 0 ? 0 : earnedPoints / totalPoints;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        border: Border(
          left: BorderSide(
            color: AppColors.secondaryLightActive.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel Header
          _buildHeader(
            gradedCount: gradedCount,
            totalPoints: totalPoints,
            earnedPoints: earnedPoints,
            progressValue: progressValue,
          ),

          // Grading action area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Only show input for written questions
                  if (question.isWritten) ...[
                    Text(
                      'ASSIGN SCORE',
                      style: AppStyles.webAgBodyBold.copyWith(
                        fontSize: 10,
                        color: AppColors.whiteDarkActive,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Reuse the shared GradingInputScoreField
                    BlocBuilder<GradingCubit, GradingState>(
                      builder: (context, state) {
                        final isSavingThis =
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
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

                  // MCQ/TF: show auto-grade summary
                  if (!question.isWritten) ...[
                    AutoGradeInfoCard(question: question),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

                  // Rubric / Notes area (placeholder — ready for API)
                  Text(
                    'INSTRUCTOR NOTE',
                    style: AppStyles.webAgBodyBold.copyWith(
                      fontSize: 10,
                      color: AppColors.whiteDarkActive,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.secondaryLightActive.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    child: TextField(
                      maxLines: 4,
                      style:
                          AppStyles.webAgBodyRegular.copyWith(fontSize: 13),
                      decoration: InputDecoration(
                        hintText:
                            'Add a note for this question (optional)...',
                        hintStyle: AppStyles.webAgBodyRegular.copyWith(
                          fontSize: 12,
                          color: AppColors.whiteDark,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required int gradedCount,
    required int totalPoints,
    required int earnedPoints,
    required double progressValue,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.secondaryLightActive.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.grading_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Grading',
                style: AppStyles.webAgBodyBold.copyWith(
                  fontSize: 14,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Score summary card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryLight,
                  AppColors.secondaryLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Score',
                      style: AppStyles.webAgBodyRegular.copyWith(
                        fontSize: 12,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      '$earnedPoints / $totalPoints pts',
                      style: AppStyles.webAgBodyBold.copyWith(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$gradedCount/${questions.length} reviewed',
                      style: AppStyles.webAgBodyRegular.copyWith(
                        fontSize: 11,
                        color: AppColors.whiteDarkActive,
                      ),
                    ),
                    Text(
                      '${(progressValue * 100).toStringAsFixed(0)}%',
                      style: AppStyles.webAgBodyBold.copyWith(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
