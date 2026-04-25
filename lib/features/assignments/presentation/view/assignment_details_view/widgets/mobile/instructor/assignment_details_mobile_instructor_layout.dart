import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/add_new_items_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_schedule_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_list.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/instructor/assignment_actions_list.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/instructor/assignment_instructor_banner.dart';

class AssignmentDetailsMobileInstructorLayout extends StatelessWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsMobileInstructorLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Dynamic Header Section (Title, Course Name, Description)
            AssignmentDetailsHeader(
              assignment: assignment,
              courseId: courseId,
            ),

            //* Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AssignmentDetailsScheduleCard(assignment: assignment),
                  const SizedBox(height: 24),


                  AssignmentStatsRow(assignment: assignment),
                  const SizedBox(height: 24),

                  AssignmentItemsList(assignment: assignment),
                  const SizedBox(height: 24),
                  
                  AddNewItemsCard(assignment: assignment, courseId: courseId),
                  const SizedBox(height: 24),

                  AssignmentInstructorBanner(assignment: assignment),
                  const SizedBox(height: 24),

                  AssignmentActionsList(
                    assignment: assignment,
                    courseId: courseId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
