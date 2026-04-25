import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/mobile/assignment_submission_mobile_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/web/assignment_submission_web_layout.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';

class AssignmentSubmissionView extends StatelessWidget {
  const AssignmentSubmissionView({super.key, required this.assignmentId});
  final String assignmentId ;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssignmentSubmissionCubit(getIt<AssignmentSubmissionRepo>())..getAllSubmissions(assignmentId: assignmentId),
      child: AdaptiveLayout(
        mobileLayout: (context) =>  AssignmentSubmissionMobileLayout(assignmentId: assignmentId,),
        webLayout: (context) =>  AssignmentSubmissionWebLayout(assignmentId: assignmentId),
      ),
    );
  }
}
