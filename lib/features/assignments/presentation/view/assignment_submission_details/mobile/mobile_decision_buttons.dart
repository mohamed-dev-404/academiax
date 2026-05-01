import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/grade_submission_request.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/submission_action_extention.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/animated_decision_button.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';

class MobileDecisionButtons extends StatelessWidget {
  const MobileDecisionButtons({super.key, required this.submissionId});
  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedDecisionButton(
            text: 'Accept',
            icon: Icons.check,
            color: Colors.teal,
            bgColor: const Color(0xFFE8F5F2),
            onTap: () {
              // Call gradeSubmission with "approved" action
              context.read<AssignmentSubmissionCubit>().gradeSubmission(
                    submissionId: submissionId,
                    request: GradeSubmissionRequest(action: SubmissionAction.approved),
                  );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnimatedDecisionButton(
            text: 'Reject',
            icon: Icons.close,
            color: Colors.red,
            bgColor: const Color(0xFFFDECEC),
            onTap: () {
              // Call gradeSubmission with "rejected" action
              context.read<AssignmentSubmissionCubit>().gradeSubmission(
                    submissionId: submissionId,
                    request: GradeSubmissionRequest(action: SubmissionAction.rejected),
                  );
            },
          ),
        ),
      ],
    );
  }
}