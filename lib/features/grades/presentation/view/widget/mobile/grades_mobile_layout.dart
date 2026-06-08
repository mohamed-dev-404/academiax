import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/features/grades/presentation/view/instructor/mobile/instructor_grades_mobile_layout.dart';
import 'package:sams_app/features/grades/presentation/view/student/mobile/student_grades_mobile_layout.dart';

/// Mobile layout entry point for grades.
/// Determines which view to show based on the user role.
///
/// Currently defaults to Instructor view for demonstration.
/// When backend is connected, this will check the authenticated user's role.
class GradesMobileLayout extends StatelessWidget {
  const GradesMobileLayout({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    if (CurrentRole.role == UserRole.instructor) {
      return InstructorGradesMobileLayout(courseId: courseId);
    }
    return const StudentGradesMobileLayout();
  }
}
