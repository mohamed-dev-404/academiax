import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/assignment_submission_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/approve_all_button.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/assign_submission_states_bar.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionWebLayout extends StatefulWidget {
  const AssignmentSubmissionWebLayout({
    super.key,
    required this.assignmentId,
    required this.enablePlagiarismCheck,
  });

  final String assignmentId;
  final bool enablePlagiarismCheck;

  @override
  State<AssignmentSubmissionWebLayout> createState() =>
      _AssignmentSubmissionWebLayoutState();
}

class _AssignmentSubmissionWebLayoutState
    extends State<AssignmentSubmissionWebLayout> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    
    ///Scroll controller to trigger pagination.
    scrollController = ScrollController();
    
    /// Pagination listener:
    /// When user scrolls near the bottom (within 300px),
    /// and there is more data available, we fetch the next page.
    scrollController.addListener(() {
      final cubit = context.read<AssignmentSubmissionCubit>();

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300 &&
          !cubit.isLoadingMore &&
          cubit.hasNextPage) {
        cubit.getAllSubmissions(
          assignmentId: widget.assignmentId,
          page: cubit.currentPage + 1,
          showLoading: false, // avoid full-screen loader for pagination
        );
      }
    });
    
    /// Initial API call after first frame render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentSubmissionCubit>().getAllSubmissions(
        assignmentId: widget.assignmentId,
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssignmentSubmissionCubit, AssignmentSubmissionState>(
      listener: (context, state) {
        if (state is ApproveAllSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
          /// Silent refresh after approval without loading UI flicker
          context.read<AssignmentSubmissionCubit>().getAllSubmissions(
            assignmentId: widget.assignmentId,
            showLoading: false,
          );
        }

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
              controller: scrollController,
              slivers: [
               /// ================= HEADER SECTION =================
                /// Shows page title and animation
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        Lottie.asset(AppLottie.quizSubmissions, width: 180),
                        const SizedBox(width: 16),
                        Text(
                          'Assignment Submissions',
                          style: AppStyles.mobileBodyXXlargeMd.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// ================= MAIN BODY =================
                BlocBuilder<
                    AssignmentSubmissionCubit,
                    AssignmentSubmissionState>(
                  builder: (context, state) {
                    /// Holds current UI data (keeps UI stable across states)
                    dynamic displayData;
                    
                    /// Accept data from different states that already contain submissions
                    if (state is SubmissionsSuccess) {
                      displayData = state.submissions;
                    } else if (state is ApproveAllLoading) {
                      displayData = state.submissions;
                    } else if (state is ApproveAllSuccess) {
                      displayData = state.submissions;
                    }

                    /// Show full loader only on first initial load
                    if (state is SubmissionsLoading &&
                        displayData == null) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: AppAnimatedLoadingIndicator(),
                        ),
                      );
                    }

                    /// Show error only if no cached data exists
                    if (state is SubmissionsFailure &&
                        displayData == null) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('Failed to load submissions'),
                        ),
                      );
                    }
                    
                    /// If no data available yet, render empty widget
                    if (displayData == null) {
                      return const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      );
                    }
                    
                     /// Extract submissions list
                    final List<AssSubmissionModel> allList =
                        displayData.submissions;

                    /// Split submissions into categories
                    final gradedList = allList
                        .where((e) => e.neededReview == false)
                        .toList();

                    final needsReviewList = allList
                        .where((e) => e.neededReview == true)
                        .toList();

                    return SliverList(
                      delegate: SliverChildListDelegate([

                        /// ================= STATS BAR =================
                        AssignSubmissionsStatsBar(
                          totalSubmitted: displayData.stats.submitted,
                          totalMarked: displayData.stats.marked,
                          totalUnmarked: displayData.stats.unmarked,
                        ),

                        const SizedBox(height: 20),

                         /// ================= EMPTY STATE =================
                        if (allList.isEmpty) ...[
                          Lottie.asset(AppLottie.empty, width: 200),
                          const SizedBox(height: 10),
                          const Text('No submissions yet!'),
                        ] else ...[
                          /// ================= NEEDS REVIEW SECTION =================
                          if (needsReviewList.isNotEmpty) ...[
                            _sectionTitle('Needs Review', Colors.orange),
                            ...needsReviewList
                                .map((e) => _submissionCard(context, e)),
                          ],

                          /// ================= GRADED SECTION =================
                          if (gradedList.isNotEmpty) ...[
                            _sectionTitle('Graded', Colors.green),
                            ...gradedList
                                .map((e) => _submissionCard(context, e)),
                          ],

                          const SizedBox(height: 20),

                          /// ================= PAGINATION LOADER =================
                          BlocBuilder<
                              AssignmentSubmissionCubit,
                              AssignmentSubmissionState>(
                            builder: (context, state) {
                              final cubit = context
                                  .read<AssignmentSubmissionCubit>();

                              /// Show loader only when fetching next page
                              if (cubit.isLoadingMore) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: AppAnimatedLoadingIndicator(),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                          
                          /// ================= APPROVE ALL BUTTON =================
                          /// Only visible if:
                          /// - plagiarism check enabled
                          /// - there are items needing review
                          if (widget.enablePlagiarismCheck &&
                              needsReviewList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20),
                              child: Center(
                                child: SizedBox(
                                  width: 180,
                                  height: 45,
                                  child: ApproveAllButton(
                                    isLoading: state is ApproveAllLoading,
                                    isSuccess: state is ApproveAllSuccess,
                                    onTap: () {
                                      context
                                          .read<
                                              AssignmentSubmissionCubit>()
                                          .approveAllSubmissions(
                                            assignmentId:
                                                widget.assignmentId,
                                          );
                                    },
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 80),
                        ],
                      ]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 4, height: 24, color: color),
          const SizedBox(width: 12),
          Text(title, style: AppStyles.mobileBodyXXlargeMd),
        ],
      ),
    );
  }

  Widget _submissionCard(BuildContext context, AssSubmissionModel item) {
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
  }
}