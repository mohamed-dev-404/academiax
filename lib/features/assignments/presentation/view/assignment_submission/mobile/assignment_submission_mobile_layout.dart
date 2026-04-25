import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
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
  const AssignmentSubmissionMobileLayout({super.key, required this.assignmentId});
  final String assignmentId;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      context
          .read<AssignmentSubmissionCubit>()
          .getAllSubmissions(assignmentId: assignmentId);
    }

    return Scaffold(
      appBar: const MobileCustomAppBar(
        title: 'Assignmet Submission',
        titleStyle: TextStyle(fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
              builder: (context, state) {
                if (state is SubmissionsLoading) {
                  return const Center(
                              child: AppAnimatedLoadingIndicator(),
                            );
                } else if (state is SubmissionsFailure) {
                  return const Center(
                    child: Text('Failed to load submissions'),
                  );
                }
                int totalSubmitted = 0;
                int totalMarked = 0;
                int totalUnmarked = 0;
                List<AssSubmissionModel> gradedList = [];
                List<AssSubmissionModel> neddedReviewList = [];
                if (state is SubmissionsSuccess) {
                  final allList = state.submissions.submissions;
                  gradedList = allList
                      .where((e) => e.neededReview == true)
                      .toList();
                  neddedReviewList = allList
                      .where((e) => e.neededReview == false)
                      .toList();
                  final submissions = state.submissions;
                  totalSubmitted = submissions.stats.submitted;
                  totalMarked = submissions.stats.marked;
                  totalUnmarked = submissions.stats.unmarked;
                  return CustomScrollView(
                    slivers: [
                      /// HEADER
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: AppColors.secondaryLightActive,
                            ),
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
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),

                      /// STATS
                      SliverToBoxAdapter(
                        child: AssignSubmissionsStatsBar(
                          totalSubmitted: totalSubmitted,
                          totalMarked: totalMarked,
                          totalUnmarked: totalUnmarked,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),

                      /// if no submissions
                      if (allList.isEmpty)
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Lottie.asset(AppLottie.empty, width: 200),
                              const SizedBox(height: 12),
                              Text(
                                'No submissions yet!',
                                style: AppStyles.mobileBodyLargeSb,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        /// ================= NEED REVIEW =================
                        if (neddedReviewList.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: _buildSectionTitle(
                              'Needs Review',
                              Colors.orange,
                            ),
                          ),
                          _buildSubmissionSliverList(neddedReviewList),
                        ],

                        /// ================= GRADED =================
                        if (gradedList.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: _buildSectionTitle('Graded', Colors.green),
                          ),
                          _buildSubmissionSliverList(gradedList),
                        ],
                      ],

                      /// APPROVE ALL BUTTON
                      SliverToBoxAdapter(
                        child: Center(
                          child: SizedBox(
                            width: 180,
                            child: ApproveAllButton(
                              onTap: () {},
                            ),
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
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

  SliverList _buildSubmissionSliverList(List<AssSubmissionModel> list) {
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SubmissionCard(
            studentName: item.studentInfo.name,
            academicId: item.studentInfo.academicId,
            formattedTime: item.formattedTime,
            displayScore: item.earnedPoints.toString(),
            maxScore: item.points.toString(),
            isGraded: !item.neededReview,
            onTap: () {
              // TODO: navigate
            },
          ),
        );
      },
    );
  }
}
