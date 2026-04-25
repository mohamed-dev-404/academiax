import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/ass_submission_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/assign_submission_states_bar.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionWebLayout extends StatelessWidget {
  const AssignmentSubmissionWebLayout({
    super.key,
    required this.assignmentId,
  });

  final String assignmentId;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      context
          .read<AssignmentSubmissionCubit>()
          .getAllSubmissions(assignmentId: assignmentId);
    }

    return Scaffold(
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

                      BlocBuilder<AssignmentSubmissionCubit,
                          AssignmentSubmissionState>(
                        builder: (context, state) {
                          if (state is SubmissionsLoading ) {
                            return const Center(
                              child: AppAnimatedLoadingIndicator(),
                            );
                          }

                          if (state is SubmissionsFailure) {
                            return Center(
                              child: Text(
                                state.errMessage,
                                style: AppStyles.mobileBodyLargeMd.copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            );
                          }

                          int totalSubmitted = 0;
                          int totalMarked = 0;
                          int totalUnmarked = 0;

                          List<AssSubmissionModel> gradedList = [];
                          List<AssSubmissionModel> needsReviewList = [];

                          if (state is SubmissionsSuccess) {
                            final data = state.submissions;

                            final allList = data.submissions;

                            gradedList = allList
                                .where((e) => e.neededReview == false)
                                .toList();

                            needsReviewList = allList
                                .where((e) => e.neededReview == true)
                                .toList();

                            totalSubmitted = data.stats.submitted;
                            totalMarked = data.stats.marked;
                            totalUnmarked = data.stats.unmarked;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              /// STATS
                              AssignSubmissionsStatsBar(
                                totalSubmitted: totalSubmitted,
                                totalMarked: totalMarked,
                                totalUnmarked: totalUnmarked,
                              ),

                              const SizedBox(height: 48),

                              /// EMPTY STATE
                              if (state is SubmissionsSuccess &&
                                  state.submissions.submissions.isEmpty) ...[
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
                                    style: AppStyles.mobileBodyLargeSb,
                                  ),
                                ),
                              ] else ...[
                                /// NEEDS REVIEW
                                if (needsReviewList.isNotEmpty) ...[
                                  _buildSectionTitle(
                                    'Needs Review',
                                    Colors.orange,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildGrid(needsReviewList, context),
                                  const SizedBox(height: 40),
                                ],

                                /// GRADED
                                if (gradedList.isNotEmpty) ...[
                                  _buildSectionTitle('Graded', Colors.green),
                                  const SizedBox(height: 20),
                                  _buildGrid(gradedList, context),
                                ],
                              ],

                              const SizedBox(height: 80),
                            ],
                          );
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
          studentName: item.studentInfo.name,
          academicId: item.studentInfo.academicId,
          formattedTime: item.formattedTime,
          displayScore: item.earnedPoints.toString(),
          maxScore: item.points.toString(),
          isGraded: !item.neededReview,
          onTap: () {},
        );
      },
    );
  }
}