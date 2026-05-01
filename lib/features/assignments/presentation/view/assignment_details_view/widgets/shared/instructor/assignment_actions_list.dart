import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/logic/assignment_action_type.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/instructor/assignment_instructor_action_card.dart';

class AssignmentActionsList extends StatelessWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentActionsList({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructor Tools',
          style: AppStyles.mobileTitleSmallSb.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),

        if (assignment.state == AssignmentState.onGoing) ...[
          const _OngoingSubmissionBanner(),
          const SizedBox(height: 16),
        ],

        ..._getActionsForState(assignment.state).map((actionType) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AssignmentInstructorActionCard(
              title: AssignmentActionUIHelper.getTitle(actionType),
              subtitle: AssignmentActionUIHelper.getSubtitle(actionType),
              icon: AssignmentActionUIHelper.getIcon(actionType),
              onTap: () {
                // AssignmentNavigationHandler.execute(
                //   context: context,
                //   action: actionType,
                //   assignment: assignment,
                //   courseId: courseId,
                // );
                context.push(
                  RoutesName.assignmentSubmission,
                  extra: {
                    'assignmentId': assignment.id,
                    'courseId': courseId,
                    'enablePlagiarismCheck': assignment.enablePlagiarismCheck,
                  }, 
                );
                // context.push(
                //   RoutesName.submissionDetails,
                //   extra: {
                //     'assignmentId': assignment.id,
                //     'courseId': courseId,

                //   },
                // );
              },
            ),
          );
        }),
      ],
    );
  }

  List<AssignmentActionType> _getActionsForState(AssignmentState state) {
    switch (state) {
      case AssignmentState.available:
        return [
          AssignmentActionType.uploadInstructions,
          //  AssignmentActionType.addReferenceFiles,
        ];
      case AssignmentState.onGoing:
        return [
          AssignmentActionType.viewSubmissions,
          //  AssignmentActionType.addReferenceFiles,
        ];
      case AssignmentState.closed:
        return [
       //    AssignmentActionType.viewSubmissions,
          AssignmentActionType.gradeSubmissions,
          //AssignmentActionType.viewAnalytics,
        ];
      default:
        return [];
    }
  }
}

class _OngoingSubmissionBanner extends StatelessWidget {
  const _OngoingSubmissionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLightActive),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_outline_rounded,
                color: AppColors.primaryDark,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Submissions in Progress',
                  style: AppStyles.mobileBodySmallSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'You can track student submissions in real-time. Final grading will be available once the deadline passes.',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.primaryDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
