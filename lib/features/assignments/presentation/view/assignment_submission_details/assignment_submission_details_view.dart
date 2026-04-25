import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/assignment_submission_details_mobile_layout.dart';

class AssignmentSubmissionDetailsView extends StatelessWidget {
  const AssignmentSubmissionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) =>
          const AssignmentSubmissionDetailsMobileLayout(),
      webLayout: (context) => const Placeholder(),
    );
  }
}
