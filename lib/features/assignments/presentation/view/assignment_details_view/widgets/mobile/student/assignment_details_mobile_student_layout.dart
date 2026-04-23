import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/work_submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_attached_files_list.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_stats_row.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/app_instructions_section.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/student/assignment_student_action_card.dart';

class AssignmentDetailsMobileStudentLayout extends StatefulWidget {
  final AssignmentModel assignment;
  final String courseId;

  const AssignmentDetailsMobileStudentLayout({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  @override
  State<AssignmentDetailsMobileStudentLayout> createState() =>
      _AssignmentDetailsMobileStudentLayoutState();
}

class _AssignmentDetailsMobileStudentLayoutState
    extends State<AssignmentDetailsMobileStudentLayout> {
  List<PlatformFile> myPickedFiles = [];
  @override
  Widget build(BuildContext context) {
    final bool isExpired = widget.assignment.dueDate.isBefore(DateTime.now());
    final bool isSubmitted =
        widget.assignment.status == AssignmentStatus.handedIn;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AssignmentDetailsHeader(
              assignment: widget.assignment,
              courseId: widget.courseId,
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

                  AssignmentStatsRow(assignment: widget.assignment),
                  const SizedBox(height: 24),

                  AssignmentItemsList(assignment: widget.assignment),
                  const SizedBox(height: 24),

                  AssignmentStudentActionCard(
                    assignment: widget.assignment,
                    onUploadPressed: () {
                      _showWorkSubmissionSheet(
                        context,
                        widget.assignment,
                        myPickedFiles,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  if (widget.assignment.status != AssignmentStatus.missed) ...[
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

  void _showWorkSubmissionSheet(
    BuildContext context,
    AssignmentModel assignment,
    List<PlatformFile> myPickedFiles,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.5, 
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return WorkSubmissionCard(
                status: assignment.status,
                /// Pass selected files to child
                pickedFiles: myPickedFiles,
                /// Receive selected files from child
                onFilesPicked: (newFiles) {
                  // Add new files to list
                  setState(() => myPickedFiles.addAll(newFiles));
                  setModalState(() {});
                },
                /// Remove file
                onRemoveFile: (index) {
                  setState(() => myPickedFiles.removeAt(index));
                  setModalState(() {});
                },
                onActionPressed: () {},
              );
            },
          ),
        );
      },
    );
  }
}
