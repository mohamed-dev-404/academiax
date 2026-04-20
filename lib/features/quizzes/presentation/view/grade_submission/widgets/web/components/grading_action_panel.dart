import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/grading_input_score_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/auto_grade_info_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';

/// Right sidebar panel for the web grading layout.
///
class GradingActionPanel extends StatelessWidget {
  final StudentSubmissionModel question;
  final List<StudentSubmissionModel> questions;

  const GradingActionPanel({
    super.key,
    required this.question,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = SizeConfig.screenWidth(context);

    final bool isSamll = screenWidth < 630;
    final bool isVerySmall = screenWidth < 530;

    final int gradedCount = questions
        .where((q) => q.state != QuestionUIState.unmarked)
        .length;
    final num totalPoints = questions.fold(0, (sum, q) => sum + q.points);
    final num earnedPoints = questions.fold(
      0,
      (sum, q) => sum + q.earnedPoints,
    );
    final double progressValue = totalPoints == 0
        ? 0
        : earnedPoints / totalPoints;

    return Container(
      width: isVerySmall
          ? 170
          : isSamll
          ? 200
          : 300,

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
            isVerySmall: isVerySmall,
            isSamll: isSamll,
          ),

          // Grading action area
          Padding(
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
                  const SizedBox(height: 24),

                  // Reuse the shared GradingInputScoreField
                  BlocBuilder<GradingCubit, GradingState>(
                    builder: (context, state) {
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: GradingInputScoreField(
                          key: ValueKey(question.id),
                          question: question,
                          onSave: (score) {
                            context.read<GradingCubit>().gradeWrittenQuestion(
                              questionId: question.id,
                              score: score,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],

                // MCQ/TF: show auto-grade summary
                if (!question.isWritten) ...[
                  AutoGradeInfoCard(question: question),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required int gradedCount,
    required num totalPoints,
    required num earnedPoints,
    required double progressValue,
    required bool isVerySmall,
    required bool isSamll,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.h, 24, 20.h, 20),
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
                        fontSize: isVerySmall
                            ? 9
                            : isSamll
                            ? 10
                            : 12,
                        color: AppColors.primaryDark,
                      ),
                    ),

                    //                      const SizedBox(width: 10),
                    Text(
                      '$earnedPoints / $totalPoints pts',
                      style: AppStyles.webAgBodyBold.copyWith(
                        fontSize: isVerySmall
                            ? 7
                            : isSamll
                            ? 10
                            : 13,
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
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
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
                        fontSize: isVerySmall
                            ? 7
                            : isSamll
                            ? 10
                            : 11,
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
