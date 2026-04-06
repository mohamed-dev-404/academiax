import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/mcq_options_list.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/question_state_chip.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/shared/written_answer.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/dot_indicator.dart';

/// Center panel for the web grading layout.
///
/// Displays: top bar with question counter and state chip,
/// scrollable question text + student answer body,
/// bottom navigation with prev/next and dot indicators.
class QuestionDetailPanel extends StatelessWidget {
  final SubmissionDetailsModel question;
  final int questionIndex;
  final int totalCount;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const QuestionDetailPanel({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.totalCount,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar
        _buildTopBar(context),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question header badges
                _buildBadgesRow(),
                const SizedBox(height: 24),

                // Question text
                Text(
                  question.text,
                  style: AppStyles.webAgBodyBold.copyWith(
                    fontSize: 16,
                    color: AppColors.primaryDarkActive,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 28),

                // Divider
                Divider(
                  color:
                      AppColors.secondaryLightActive.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 20),

                // Student Answer section label
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 16,
                      color: AppColors.whiteDarkActive,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'STUDENT ANSWER',
                      style: AppStyles.webAgBodyBold.copyWith(
                        fontSize: 10,
                        color: AppColors.whiteDarkActive,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Answer body
                if (question.isWritten)
                  WrittenAnswer(answer: question.writtenAnswer)
                else if (question.options != null)
                  McqOptionsList(options: question.options!),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),

        // Bottom nav
        _buildBottomNav(),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        border: Border(
          bottom: BorderSide(
            color: AppColors.secondaryLightActive.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Question ${questionIndex + 1} of $totalCount',
            style: AppStyles.webAgBodyBold.copyWith(
              fontSize: 13,
              color: AppColors.primaryDark,
            ),
          ),
          const Spacer(),
          QuestionStateChip(question: question),
        ],
      ),
    );
  }

  Widget _buildBadgesRow() {
    final bool isWritten = question.isWritten;
    final Color typeColor =
        isWritten ? AppColors.primary : AppColors.secondary;
    final IconData typeIcon = isWritten
        ? Icons.description_outlined
        : Icons.fact_check_outlined;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: typeColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(typeIcon, size: 13, color: typeColor),
              const SizedBox(width: 6),
              Text(
                question.uiTypeLabel.toUpperCase(),
                style: AppStyles.webAgBodyBold.copyWith(
                  fontSize: 10,
                  color: typeColor,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        // Points badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            '${question.points} pts',
            style: AppStyles.webAgBodyBold.copyWith(
              fontSize: 10,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        border: Border(
          top: BorderSide(
            color: AppColors.secondaryLightActive.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Prev
          TextButton.icon(
            onPressed: onPrev,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
            label: const Text('Previous'),
            style: TextButton.styleFrom(
              foregroundColor: onPrev != null
                  ? AppColors.primaryDark
                  : AppColors.whiteDark,
            ),
          ),

          // Dot indicators (max 10 shown)
          DotIndicator(
            total: totalCount,
            current: questionIndex,
          ),

          // Next
          TextButton.icon(
            onPressed: onNext,
            icon: const Text('Next'),
            label: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            style: TextButton.styleFrom(
              foregroundColor: onNext != null
                  ? AppColors.primaryDark
                  : AppColors.whiteDark,
            ),
          ),
        ],
      ),
    );
  }
}
