import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/logic/instructor_action_handler.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/logic/quiz_action_type.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/instructor/teacher_action_card.dart';

class InstructorActionsList extends StatelessWidget {
  final QuizModel quiz;
  final String courseId;

  const InstructorActionsList({
    super.key,
    required this.quiz,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    // Hide component if the quiz is in a locked draft state
    if (quiz.state == QuizState.lockedDraft) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Management Tools',
          style: AppStyles.mobileTitleSmallSb.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),

        // 1. Show the status banner only for ongoing quizzes
        if (quiz.state == QuizState.onGoing) ...[
          const _OngoingStatusBanner(),
          const SizedBox(height: 16),
        ],

        // 2. Map allowed actions for the current state to TeacherActionCards
        ..._getActionsForState(quiz.state).map((actionType) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TeacherActionCard(
              title: QuizActionUIHelper.getTitle(actionType),
              subtitle: QuizActionUIHelper.getSubtitle(actionType),
              icon: QuizActionUIHelper.getIcon(actionType),
              onTap: () => InstructorActionHandler.execute(
                context: context,
                action: actionType,
                quiz: quiz,
                courseId: courseId,
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Defines which actions are visible based on the QuizState
  List<QuizActionType> _getActionsForState(QuizState state) {
    switch (state) {
      case QuizState.draft:
        return [QuizActionType.addQuestions];
      case QuizState.scheduled:
        return [QuizActionType.manageQuestions];
      case QuizState.onGoing:
        return [QuizActionType.viewQuestions];
      case QuizState.completed:
        return [
          QuizActionType.viewSubmissions,
          QuizActionType.viewQuestions,
        ];
      default:
        return [];
    }
  }
}

class _OngoingStatusBanner extends StatelessWidget {
  const _OngoingStatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenLight.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greenLightActive, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildLiveDot(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quiz is currently Live',
                  style: AppStyles.mobileBodySmallSb.copyWith(
                    color: AppColors.greenDarkActive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Submissions list will be available immediately after the quiz ends. Students are currently submitting their answers.',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.greenDark, // Fixed: Using standard AppColors
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildLiveDot() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greenHover, width: 1.5),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: AppColors.greenHover,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: const LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
        backgroundColor: AppColors.greenLightActive,
        minHeight: 4,
      ),
    );
  }
}
