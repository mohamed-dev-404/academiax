import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/similarity_item.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class SimilarityReportDialog extends StatelessWidget {
  final String submissionId;
  final AssignmentSubmissionCubit cubit;

  const SimilarityReportDialog({
    super.key,
    required this.submissionId,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..getSimilarityReport(submissionId: submissionId),
      child: BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
        buildWhen: (previous, current) =>
            current is SimilarityReportLoading ||
            current is SimilarityReportSuccess ||
            current is SimilarityReportFailure,
        builder: (context, state) {
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              state is SimilarityReportSuccess
                  ? 'Report for ${state.report.studentName}'
                  : 'Similarity Report',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 300,
              ),
              child: SizedBox(
                width: double.maxFinite,
                child: _buildDialogContent(state),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Color(0xFF007A92)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDialogContent(AssignmentSubmissionState state) {
    if (state is SimilarityReportLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state is SimilarityReportFailure) {
      return Text(state.errMessage);
    } else if (state is SimilarityReportSuccess) {
      final report = state.report;
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Text('Threshold: ${report.assignmentPlagiarismThreshold}%'),
            const Divider(),
            ...report.similarities
                    ?.map(
                      (similarity) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SimilarityItem(
                          percentage: similarity.similarityPercentage ?? 0,
                          text: 'Similar to ${similarity.studentName}',
                          url: similarity.submissionUrl,
                          assignmentPlagiarismThreshold:
                              report.assignmentPlagiarismThreshold ?? 0,
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
