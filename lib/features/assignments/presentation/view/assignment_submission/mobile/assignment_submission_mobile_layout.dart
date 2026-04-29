import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/ass_submission_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/approve_all_button.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/assign_submission_states_bar.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionMobileLayout extends StatelessWidget {
  const AssignmentSubmissionMobileLayout({
    super.key,
    required this.assignmentId,
    required this.enablePlagiarismCheck,
  });

  final String assignmentId;
  final bool enablePlagiarismCheck;

  @override
  Widget build(BuildContext context) {
    // Initial data fetch when the screen is first opened
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      context.read<AssignmentSubmissionCubit>().getAllSubmissions(
            assignmentId: assignmentId,
          );
    }

    return BlocListener<AssignmentSubmissionCubit, AssignmentSubmissionState>(
      listener: (context, state) {
        // Show success message when "Approve All" succeeds
        if (state is ApproveAllSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message ,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
         // Silent refresh to fetch updated data without showing full-screen loading
          context.read<AssignmentSubmissionCubit>().getAllSubmissions(
                assignmentId: assignmentId,
                showLoading: false,
              );
        }
       // Show error message if "Approve All" fails
        if (state is ApproveAllFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const MobileCustomAppBar(
          title: 'Assignment Submission',
          titleStyle: TextStyle(fontSize: 20),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
            builder: (context, state) {
               // Determine the data source to keep UI stable during button loading states
              dynamic displayData;
              if (state is SubmissionsSuccess) {
                displayData = state.submissions;
              } else if (state is ApproveAllLoading) {
                displayData = state.submissions;
              } else if (state is ApproveAllSuccess) {
                displayData = state.submissions;
              }
               // Show full-screen loading only if there is no existing data
              if (state is SubmissionsLoading && displayData == null) {
                return const Center(child: AppAnimatedLoadingIndicator());
              }

              if (state is SubmissionsFailure && displayData == null) {
                return const Center(child: Text('Failed to load submissions'));
              }
              // If data exists, build the UI
              if (displayData != null) {
                // Extract full submissions list
                final List<AssSubmissionModel> allList = displayData.submissions;
                final gradedList = allList.where((e) => e.neededReview == false).toList();
                final neddedReviewList = allList.where((e) => e.neededReview == true).toList();

                return CustomScrollView(
                  slivers: [
                    /// HEADER SECTION
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(color: AppColors.secondaryLightActive),
                        ),
                        child: Column(
                          children: [
                            Lottie.asset(AppLottie.quizSubmissions),
                            const SizedBox(height: 8),
                            Text(
                              'Submissions Overview',
                              style: AppStyles.mobileTitleSmallSb,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                     /// STATS BAR (submitted / marked / unmarked)
                    SliverToBoxAdapter(
                      child: AssignSubmissionsStatsBar(
                        totalSubmitted: displayData.stats.submitted,
                        totalMarked: displayData.stats.marked,
                        totalUnmarked: displayData.stats.unmarked,
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    /// EMPTY STATE
                    if (allList.isEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Lottie.asset(AppLottie.empty, width: 200),
                            Text(
                              'No submissions yet!',
                              style: AppStyles.mobileBodyLargeSb,
                            ),
                          ],
                        ),
                      )
                    else ...[
                      /// NEEDS REVIEW SECTION
                      if (neddedReviewList.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _buildSectionTitle('Needs Review', Colors.orange),
                        ),
                        _buildSubmissionSliverList(list: neddedReviewList),
                      ],

                      /// GRADED SECTION
                      if (gradedList.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _buildSectionTitle('Graded', Colors.green),
                        ),
                        _buildSubmissionSliverList(list: gradedList),
                      ],

                      /// APPROVE ALL BUTTON
                      if (enablePlagiarismCheck && neddedReviewList.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: SizedBox(
                                width: 180,
                                child: ApproveAllButton(
                                  isLoading: state is ApproveAllLoading,
                                  isSuccess: state is ApproveAllSuccess,
                                  onTap: () {
                                    context.read<AssignmentSubmissionCubit>().approveAllSubmissions(
                                          assignmentId: assignmentId,
                                        );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(title, style: AppStyles.mobileBodyLargeSb),
        ],
      ),
    );
  }

  SliverList _buildSubmissionSliverList({
    required List<AssSubmissionModel> list,
  }) {
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SubmissionCard(
            studentName: item.studentInfo.name ?? '',
            academicId: item.studentInfo.academicId ?? '',
            formattedTime: item.formattedTime,
            displayScore: item.earnedPoints.toString(),
            maxScore: item.points.toString(),
            isGraded: !item.neededReview,
            onTap: () {
              context.push(
                RoutesName.submissionDetails,
                extra: {
                  'submissionId': item.id,
                  'courseId': '',
                },
              );
            },
          ),
        );
      },
    );
  }
}