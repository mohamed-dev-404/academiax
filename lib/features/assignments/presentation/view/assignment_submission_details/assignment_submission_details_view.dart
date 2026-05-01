import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/assignment_submission_details_mobile_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/web/assignment_submission_details_web_layout.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';

class AssignmentSubmissionDetailsView extends StatelessWidget {
  const AssignmentSubmissionDetailsView({
    super.key,
    required this.submissionId,
  });
  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssignmentSubmissionCubit>()..getSubmissionDetails(submissionId: submissionId),
      child: AdaptiveLayout(
        mobileLayout: (context) =>
              AssignmentSubmissionDetailsMobileLayout(submissionId: submissionId,),
        webLayout: (context) =>  AssignmentSubmissionDetailsWebLayout(submissionId: submissionId,
        ),
      ),
    );
  }
}
