import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_grid.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/app_instructions_section.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/assignment_student_action_card.dart';

class AssignmentDetailsWebStudentLayout extends StatelessWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsWebStudentLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: width > 940
            ? _buildDesktopLayout(context)
            : _buildTabletLayout(context),
      ),
    );
  }

  // * 1. Desktop Layout (Two Columns)
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentDetailsHeader(
          assignment: assignment,
          courseId: courseId,
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Left Column: Stats & Instructions (Main Content)
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AssignmentStatsRow(assignment: assignment),
                  const SizedBox(height: 32),
                   AssignmentContentGrid(assignment: assignment),
                  const SizedBox(height: 32),
                  _buildInstructions(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            //* Right Column: Dynamic Action Area (Sidebar)
            Expanded(
              flex: 4,
              child: _buildSideContent(context),
            ),
          ],
        ),
      ],
    );
  }

  // * 2. Tablet Layout (Single Column Stacked)
  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentDetailsHeader(
          assignment: assignment,
          courseId: courseId,
        ),
        const SizedBox(height: 32),
        AssignmentStatsRow(assignment: assignment),
        const SizedBox(height: 32),
        _buildSideContent(context),
        const SizedBox(height: 32),
        _buildInstructions(),
      ],
    );
  }

  // * 3. Instructions & Guidelines Section
  Widget _buildInstructions() {
    if (assignment.status == AssignmentStatus.missed) {
      return const SizedBox.shrink();
    }

    return const AssignmentInstructionsSection(
      title: 'Submission Instructions',
      instructions: [
        'Accepted formats: PDF, DOCX, or ZIP for multiple files.',
        'Maximum file size allowed is 50MB.',
        'Ensure your work is original to pass the plagiarism check.',
        'You can resubmit anytime before the deadline.',
      ],
    );
  }

  // * 4. Side Content (Deadline Timer & Submit Actions)
  Widget _buildSideContent(BuildContext context) {
    final bool isExpired = assignment.dueDate.isBefore(DateTime.now());
    final bool isSubmitted = assignment.status == AssignmentStatus.handedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isExpired && !isSubmitted) ...[
          // DeadlineTimer(endTime: assignment.dueDate),
          const SizedBox(height: 24),
        ],

        AssignmentStudentActionCard(
          assignment: assignment,
          onUploadPressed: () {
            context.push(
              RoutesName.createAssignment,
              extra: {
                'assignmentId': assignment.id,
                'assignmentTitle': assignment.title,
              },
            );
          },
        ),
      ],
    );
  }
}
