import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/mobile/instructor/assignment_details_mobile_instructor_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/mobile/student/assignment_details_mobile_student_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/web/instructor/assignment_details_web_instructor_layout.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/web/student/assignment_details_web_student_layout.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_state.dart';

class AssignmentDetailsView extends StatelessWidget {
  final String assignmentId;
  final String courseId;

  const AssignmentDetailsView({
    super.key,
    required this.assignmentId,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    

    // * UI Direct Rendering (No Bloc/Cubit)
    return BlocBuilder<AssignmentDetailsCubit, AssignmentDetailsState>(
      builder: (context, state) {
        if (state is AssignmentDetailsLoading) {
          return const Center(child: AppAnimatedLoadingIndicator());
        }
        if (state is AssignmentDetailsFailure) {
          return Center(child: Text(state.errMessage));
        }
       if (state is AssignmentDetailsSuccess) {
         final assignment = state.assignment;
          return AdaptiveLayout(
          // --- Mobile Layouts ---
          mobileLayout: (context) => CurrentRole.role == UserRole.instructor
              ? AssignmentDetailsMobileInstructorLayout(
                  assignment: assignment,
                  courseId: courseId,
                )
              : AssignmentDetailsMobileStudentLayout(
                  assignment: assignment,
                  courseId: courseId,
                ),

          // --- Web Layouts (Desktop/Tablet) ---
          webLayout: (context) => CurrentRole.role == UserRole.instructor
              ? AssignmentDetailsWebInstructorLayout(
                  assignment: assignment,
                  courseId: courseId,
                )
              : AssignmentDetailsWebStudentLayout(
                  assignment: assignment,
                  courseId: courseId,
                ),
        );
       }
       return Container();
      },
    );
  }
}
