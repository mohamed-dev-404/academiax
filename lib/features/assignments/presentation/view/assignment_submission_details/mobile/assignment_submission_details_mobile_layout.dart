import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/extentions/filter_files_helper.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/assignments/data/model/assignment_item_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/logic/assignment_details_handler.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/mobile_decision_buttons.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/submission_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/animated_document_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/similarity_item.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionDetailsMobileLayout extends StatelessWidget {
  const AssignmentSubmissionDetailsMobileLayout({
    super.key,
    required this.neededReview,
  });
  final bool neededReview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF158A9E),
      body: BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
        builder: (context, state) {
          if (state is SubmissionDetailsLoading) {
            return const Center(
              child: AppAnimatedLoadingIndicator(),
            );
          } else if (state is SubmissionDetailsFailure) {
            return Center(
              child: Text(state.errMessage),
            );
          } else if (state is SubmissionDetailsSuccess) {
            final items = state.details.submittedItems;
            return Column(
              children: [
                ///  Header
                SubmissionDetailsHeader(
                  studentInfo: state.details.studentInfo,
                ),

                ///  Bottom Container
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

                          ...items.map(
                            (file) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AnimatedDocumentCard(
                                title: file.originalFileName ?? '',
                                subtitle: 'Tap to open document',
                                type:
                                    file.displayUrl?.fileContentType
                                        .split('/')
                                        .last ??
                                    '',
                                icon: Icons.picture_as_pdf,
                                color: Colors.red,
                                onTap: () {
                                  final url = file.displayUrl ?? '';
                                  final itemToOpen = AssignmentItemModel(
                                    displayUrl: file.displayUrl,
                                    originalFileName: file.originalFileName,
                                  );

                                  AssignmentDetailsHandler.openMaterialItem(
                                    context,
                                    itemToOpen,
                                  );
                                },
                              ),
                            ),
                          ),

                          AnimatedDocumentCard(
                            title: 'Similarity Report',
                            subtitle: 'Preview plagiarism check',
                            type: 'View',
                            icon: Icons.search,
                            color: Colors.blue,
                            onTap: () {
                              _showSimilarityDialog(context);
                            },
                          ),

                          const SizedBox(height: 24),
                          if (neededReview)
                            const Text(
                              'Decision',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                          const SizedBox(height: 16),

                          /// Condition: only show buttons if neededReview == true
                          if (neededReview) const MobileDecisionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

void _showSimilarityDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SimilarityItem(
                percentage: 10,
                text: "Nadia's assignment is similar to Mariam's",
              ),
              SizedBox(height: 12),
              SimilarityItem(
                percentage: 80,
                text: "Nadia's assignment is similar to Mariam's",
              ),
              SizedBox(height: 12),
              SimilarityItem(
                percentage: 20,
                text: "Nadia's assignment is similar to Mariam's",
              ),
            ],
          ),
        ),
      );
    },
  );
}
