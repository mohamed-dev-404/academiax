import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/mobile/live_sessions_mobile_layout.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/web/live_sessions_web_layout.dart';

class LiveSessionsTabView extends StatelessWidget {
  final String courseId;
  final int instructorId;
  const LiveSessionsTabView({
    super.key,
    required this.courseId,
    this.instructorId = 0,
  });

  @override
  Widget build(BuildContext context) {
        final isInstructor = CurrentRole.role == UserRole.instructor;

    // Each child layout (mobile/web) has its own BlocListener that handles
    // JoinMeetingSuccess navigation and JoinMeetingFailure snackbars.
    // No top-level listener needed here.
    return AdaptiveLayout(
      mobileLayout: (context) => LiveSessionsMobileLayout(
        courseId: courseId,
        instructorId: instructorId,
        isInstructor: isInstructor,
      ),
      webLayout: (context) => LiveSessionsWebLayout(
        courseId: courseId,
        instructorId: instructorId, isInstructor: isInstructor ,
      ),
    );
  }
}