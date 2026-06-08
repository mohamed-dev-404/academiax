import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/features/grades/presentation/view/instructor/web/instructor_grades_web_layout.dart';
import 'package:sams_app/features/grades/presentation/view/student/web/student_grades_web_layout.dart';

/// Web layout entry point for grades.
/// Determines which view to show based on the user role.
///
/// Currently defaults to Instructor view for demonstration.
/// When backend is connected, this will check the authenticated user's role.
class GradesWebLayout extends StatelessWidget {
  const GradesWebLayout({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    if (CurrentRole.role == UserRole.instructor) {
      return InstructorGradesWebLayout(courseId: courseId);
    }
    return const StudentGradesWebLayout();
  }
}
