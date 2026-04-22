import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_list.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/app_instructions_section.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/assignment_student_action_card.dart';

class AssignmentDetailsMobileStudentLayout extends StatelessWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsMobileStudentLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    
    final bool isExpired = assignment.dueDate.isBefore(DateTime.now());
    final bool isSubmitted = assignment.status == AssignmentStatus.handedIn;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            AssignmentDetailsHeader(
              assignment: assignment,
              courseId: courseId,
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  if (!isExpired && !isSubmitted) ...[
                   // DeadlineTimer(endTime: assignment.dueDate),
                    const SizedBox(height: 24),
                  ],

                  AssignmentStatsRow(assignment: assignment),
                  const SizedBox(height: 24),

                   AssignmentItemsList(assignment: assignment),
                  const SizedBox(height: 24),

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

                  const SizedBox(height: 24),

                  if (assignment.status != AssignmentStatus.missed) ...[
                    const AssignmentInstructionsSection(
                      title: 'Submission Guidelines',
                      instructions: [
                        'Upload your files in PDF, PNG or JPG format.',
                        'The total file size should not exceed 25MB.',
                        'Make sure your work is original (Plagiarism check might be enabled).',
                        'You can edit your submission until the deadline.',
                      ],
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
