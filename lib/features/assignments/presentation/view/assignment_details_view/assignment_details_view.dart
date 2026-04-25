import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/helper/app_toast.dart';
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
    
    //  if (ModalRoute.of(context)?.isCurrent ?? false) {
    //   context.read<AssignmentDetailsCubit>().fetchAssignmentDetails(assignmentId: assignmentId);
    // }
    

    return BlocListener< AssignmentDetailsCubit, AssignmentDetailsState>(
      listener: (context, state) {
        if (state is DeleteAssignmentSuccess) {
          AppToast.success(context, state.message);
          context.pop();
        }
        if (state is DeleteAssignmentFailure) {
          AppToast.error(context, state.errMessage);
        }
        if (state is DeleteAssignmentItemSuccess ) {
          AppToast.success(context, state.message);
          context.read<AssignmentDetailsCubit>().updateAssignmentStateLocally(
            state.assignment,

          );
          context.pop();
        }
        if (state is DeleteAssignmentItemFailure) {
          AppToast.error(context, state.errMessage);
        }
        if (state is AddAssignmentItemsSuccess) {
          AppToast.success(context, state.message);
          context.read<AssignmentDetailsCubit>().updateAssignmentStateLocally(
            state.assignment,
          );
          context.pop();
        }
        if (state is AddAssignmentItemsFailure) {
          AppToast.error(context, state.errMessage);
        }
      },
      child: BlocBuilder<AssignmentDetailsCubit, AssignmentDetailsState >(
        
        buildWhen: (previous, current) =>
            current is AssignmentDetailsLoading ||
            current is AssignmentDetailsSuccess ||
            current is AssignmentDetailsFailure||
            current is  DeleteAssignmentItemSuccess||
            current is  AddAssignmentItemsSuccess,
        builder: (context, state) {
          if (state is AssignmentDetailsLoading) {
            return const Scaffold(body: Center(child: AppAnimatedLoadingIndicator()));
          }
          if (state is AssignmentDetailsFailure) {
            return Center(child: Text(state.errMessage));
          }
          
          if (state is AssignmentDetailsSuccess|| state is  DeleteAssignmentItemSuccess || state is  AddAssignmentItemsSuccess) {
            final assignment = (state as dynamic).assignment;
      
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
      ),
    );
  }
}
