import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/ass_submission_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/approve_all_button.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/assign_submission_states_bar.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionWebLayout extends StatelessWidget {
  const AssignmentSubmissionWebLayout({
    super.key,
    required this.assignmentId,
    required this.enablePlagiarismCheck,
  });

  final String assignmentId;
  final bool enablePlagiarismCheck;

  @override
  Widget build(BuildContext context) {
    /// Initial data fetch when screen opens
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      context.read<AssignmentSubmissionCubit>().getAllSubmissions(
            assignmentId: assignmentId,
          );
    }

    return BlocListener<AssignmentSubmissionCubit, AssignmentSubmissionState>(
      listener: (context, state) {
        /// Show success message after approve all
        if (state is ApproveAllSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );

          /// Silent refresh (no full screen loading)
          context.read<AssignmentSubmissionCubit>().getAllSubmissions(
                assignmentId: assignmentId,
                showLoading: false,
              );
        }

        /// Show error message
        if (state is ApproveAllFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(32),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            Lottie.asset(
                              AppLottie.quizSubmissions,
                              width: 200,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Assignment Submissions',
                              style: AppStyles.mobileBodyXXlargeMd.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        BlocBuilder<
                            AssignmentSubmissionCubit,
                            AssignmentSubmissionState>(
                          builder: (context, state) {
                            /// Determine data source to keep UI stable
                            dynamic displayData;

                            if (state is SubmissionsSuccess) {
                              displayData = state.submissions;
                            } else if (state is ApproveAllLoading) {
                              displayData = state.submissions;
                            } else if (state is ApproveAllSuccess) {
                              displayData = state.submissions;
                            }

                            /// Show loading only if no data exists
                            if (state is SubmissionsLoading &&
                                displayData == null) {
                              return const Center(
                                child: AppAnimatedLoadingIndicator(),
                              );
                            }

                            /// Show error only if no data exists
                            if (state is SubmissionsFailure &&
                                displayData == null) {
                              return Center(
                                child: Text(
                                  'Failed to load submissions',
                                  style: AppStyles.mobileBodyLargeMd.copyWith(
                                    color: AppColors.red,
                                  ),
                                ),
                              );
                            }

                            /// Build UI when data is available
                            if (displayData != null) {
                              final List<AssSubmissionModel> allList =
                                  displayData.submissions;

                              /// Split data
                              final gradedList = allList
                                  .where((e) => e.neededReview == false)
                                  .toList();

                              final needsReviewList = allList
                                  .where((e) => e.neededReview == true)
                                  .toList();

                              final totalSubmitted =
                                  displayData.stats.submitted;
                              final totalMarked =
                                  displayData.stats.marked;
                              final totalUnmarked =
                                  displayData.stats.unmarked;

                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  /// STATS BAR
                                  AssignSubmissionsStatsBar(
                                    totalSubmitted: totalSubmitted,
                                    totalMarked: totalMarked,
                                    totalUnmarked: totalUnmarked,
                                  ),

                                  const SizedBox(height: 48),

                                  /// EMPTY STATE
                                  if (allList.isEmpty) ...[
                                    Center(
                                      child: Lottie.asset(
                                        AppLottie.empty,
                                        width: 250,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Center(
                                      child: Text(
                                        'No submissions yet!',
                                        style:
                                            AppStyles.mobileBodyLargeSb,
                                      ),
                                    ),
                                  ] else ...[
                                    /// NEEDS REVIEW SECTION
                                    if (needsReviewList.isNotEmpty) ...[
                                      _buildSectionTitle(
                                        'Needs Review',
                                        Colors.orange,
                                      ),
                                      const SizedBox(height: 20),
                                      _buildGrid(
                                          needsReviewList, context),
                                      const SizedBox(height: 40),
                                    ],

                                    /// GRADED SECTION
                                    if (gradedList.isNotEmpty) ...[
                                      _buildSectionTitle(
                                          'Graded', Colors.green),
                                      const SizedBox(height: 20),
                                      _buildGrid(gradedList, context),
                                    ],

                                    /// APPROVE ALL BUTTON
                                    /// Same behavior as mobile
                                    if (enablePlagiarismCheck &&
                                        needsReviewList.isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        child: Center(
                                          child: SizedBox(
                                            width: 200,
                                            child: ApproveAllButton(
                                              /// Button loading state
                                              isLoading:
                                                  state is ApproveAllLoading,

                                              /// Button success state
                                              isSuccess:
                                                  state is ApproveAllSuccess,

                                              /// Trigger action
                                              onTap: () {
                                                context
                                                    .read<
                                                        AssignmentSubmissionCubit>()
                                                    .approveAllSubmissions(
                                                      assignmentId:
                                                          assignmentId,
                                                    );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],

                                  const SizedBox(height: 80),
                                ],
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
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
        Text(title, style: AppStyles.mobileBodyXXlargeMd),
      ],
    );
  }

  Widget _buildGrid(List<AssSubmissionModel> list, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width > 1100
        ? 3
        : width > 800
            ? 2
            : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 120,
      ),
      itemBuilder: (context, index) {
        final item = list[index];

        return SubmissionCard(
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
        );
      },
    );
  }
}