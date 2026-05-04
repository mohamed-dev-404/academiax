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

class AssignmentSubmissionDetailsWebLayout extends StatelessWidget {
  const AssignmentSubmissionDetailsWebLayout({
    super.key,
    required this.submissionId, // 1. Added submissionId to the constructor
  });

  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF158A9E),
      // 2. Added BlocListener to handle the post-grading refresh logic
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
            // Trigger a silent refresh (no full-screen loader) to update UI after grading
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
            } else if (state is SubmissionDetailsFailure) {
              return Center(
                child: Text(
                  state.errMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is SubmissionDetailsSuccess) {
              final details = state.details;
              final items = details.submittedItems;
              // 3. Extract the current review status from the state to control UI rebuilds
              final bool isReviewRequired = details.neededReview;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SubmissionDetailsHeader(
                            studentInfo: details.studentInfo,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            padding: const EdgeInsets.all(32),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Documents',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                          file.originalFileName ??
                                          'Unnamed File',
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
                                            originalFileName:
                                                file.originalFileName,
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
                                const SizedBox(height: 30),
                                // 4. This section will automatically disappear when isReviewRequired becomes false
                                if (isReviewRequired) ...[
                                  const Text(
                                    'Decision',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Pass submissionId to buttons to trigger the grade request
                                  MobileDecisionButtons(
                                    submissionId: submissionId,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showSimilarityDialog(BuildContext context,String submissionId,AssignmentSubmissionCubit cubit) {
    showDialog(
    context: context,
    builder: (context) => SimilarityReportDialog(
      submissionId: submissionId,
      cubit: cubit,
    ),
  );
  }
}
