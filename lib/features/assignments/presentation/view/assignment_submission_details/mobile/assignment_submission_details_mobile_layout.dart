import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/extentions/filter_files_helper.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/assignments/data/model/assignment_item_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/file_extension_helper.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/logic/assignment_details_handler.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/mobile_decision_buttons.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/similarity_report_dialog.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/submission_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/animated_document_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/similarity_item.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionDetailsMobileLayout extends StatelessWidget {
  const AssignmentSubmissionDetailsMobileLayout({
    super.key,
    required this.submissionId, // Use this for refreshing data
  });

  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF158A9E),
      // BlocListener handles the logic of what happens AFTER a successful grade
      body: BlocListener<AssignmentSubmissionCubit, AssignmentSubmissionState>(
        
        listener: (context, state) {
          if (state is GradeSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.response.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
            // Re-fetch data silently (without showing a full-screen loader)
            context.read<AssignmentSubmissionCubit>().getSubmissionDetails(
              submissionId: submissionId,
              showLoading: false,
            );
          } else if (state is GradeSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errMessage,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
          buildWhen: (previous, current) => 
      current is SubmissionDetailsLoading || 
      current is SubmissionDetailsSuccess || 
      current is SubmissionDetailsFailure,
          builder: (context, state) {
            if (state is SubmissionDetailsLoading) {
              return const Center(child: AppAnimatedLoadingIndicator());
            }

            if (state is SubmissionDetailsFailure) {
              return Center(child: Text(state.errMessage));
            }

            if (state is SubmissionDetailsSuccess) {
              final items = state.details.submittedItems;
              // Check if review is still needed based on fetched data
              final bool isReviewRequired = state.details.neededReview;

              return Column(
                children: [
                  SubmissionDetailsHeader(
                    studentInfo: state.details.studentInfo,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Documents',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Map through submitted files
                            ...items.map((file) {
                              final (
                                fileIcon,
                                fileColor,
                              ) = FileExtensionHelper.getFileTypeDetails(
                                file.originalFileName,
                              );
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AnimatedDocumentCard(
                                  title:
                                      file.originalFileName ?? 'Unnamed File',
                                  subtitle: 'Tap to preview',
                                  type:
                                      file.originalFileName
                                          ?.split('.')
                                          .last
                                          .toUpperCase() ??
                                      'FILE',
                                  icon: fileIcon,
                                  color: fileColor,
                                  onTap: () {
                                    AssignmentDetailsHandler.openMaterialItem(
                                      context,
                                      AssignmentItemModel(
                                        displayUrl: file.displayUrl,
                                        originalFileName: file.originalFileName,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            AnimatedDocumentCard(
                              title: 'Similarity Report',
                              subtitle: 'Preview plagiarism check',
                              type: 'View',
                              icon: Icons.search,
                              color: Colors.blue,
                              onTap: () => _showSimilarityDialog(context, submissionId, context.read<AssignmentSubmissionCubit>()),
                            ),
                            const SizedBox(height: 24),
                            // Section disappears automatically if isReviewRequired becomes false
                            if (isReviewRequired) ...[
                              const Text(
                                'Decision',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              MobileDecisionButtons(submissionId: submissionId),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Default fallback to avoid "dead code" warning and ensure a widget is returned
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
  void _showSimilarityDialog(BuildContext context, String submissionId, AssignmentSubmissionCubit cubit) {
  
  showDialog(
    context: context,
    builder: (context) => SimilarityReportDialog(
      submissionId: submissionId,
      cubit: cubit,
    ),
  );
}
}


