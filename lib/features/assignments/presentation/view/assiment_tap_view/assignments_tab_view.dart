import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/assignments/data/model/helper/mock_data.dart';
import 'package:sams_app/features/assignments/presentation/view/assiment_tap_view/widget/mobile/assignments_mobile_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assiment_tap_view/widget/web/assignments_web_layout.dart';

class AssignmentsTabView extends StatelessWidget {
  final String courseId;
  const AssignmentsTabView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (BuildContext context) {
        return AssignmentsMobileLayout(
          courseId: '',
          assignments: mockAssignments,
          userRole: CurrentRole.role,
        );
      },
      webLayout: (BuildContext context) {
        return AssignmentsWebLayout(
          courseId: '',
          assignments: mockAssignments,
          userRole: CurrentRole.role,
        );
      },
    );
  }
}
