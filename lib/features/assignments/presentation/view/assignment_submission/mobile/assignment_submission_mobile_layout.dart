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
import 'package:sams_app/features/assignments/data/model/get_all_submissions/assignment_submission_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/approve_all_button.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/assign_submission_states_bar.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

class AssignmentSubmissionMobileLayout extends StatefulWidget {
  const AssignmentSubmissionMobileLayout({
    super.key,
    required this.assignmentId,
    required this.enablePlagiarismCheck,
  });

  final String assignmentId;
  final bool enablePlagiarismCheck;

  @override
  State<AssignmentSubmissionMobileLayout> createState() =>
      _AssignmentSubmissionMobileLayoutState();
}

class _AssignmentSubmissionMobileLayoutState
    extends State<AssignmentSubmissionMobileLayout> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    /// ================= PAGINATION LOGIC =================
    /// When user scrolls near the bottom of the list,
    /// we trigger loading the next page if available.
    scrollController.addListener(() {
      final cubit = context.read<AssignmentSubmissionCubit>();

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300 &&
          !cubit.isLoadingMore &&
          cubit.hasNextPage) {
        cubit.getAllSubmissions(
          assignmentId: widget.assignmentId,
          page: cubit.currentPage + 1,
          showLoading: false, // avoid full-screen loader during pagination
        );
      }
    });

    /// ================= FIRST API CALL =================
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentSubmissionCubit>().getAllSubmissions(
        assignmentId: widget.assignmentId,
      );
    });
  }

  @override
  void dispose() {
    /// Prevent memory leaks
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssignmentSubmissionCubit, AssignmentSubmissionState>(
      listener: (context, state) {

        /// ================= APPROVE ALL SUCCESS =================
        /// Show success message + refresh list silently
        if (state is ApproveAllSuccess) {
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

          /// Silent refresh after approval
          context.read<AssignmentSubmissionCubit>().getAllSubmissions(
            assignmentId: widget.assignmentId,
            showLoading: false,
          );
        }

        /// ================= APPROVE ALL FAILURE =================
        /// Show error message when bulk approval fails
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

          child: BlocBuilder<
              AssignmentSubmissionCubit,
              AssignmentSubmissionState>(
            builder: (context, state) {

              /// Holds current UI-safe data to prevent flickering
              dynamic displayData;

              /// ================= STATE → DATA MAPPING =================
              /// We extract data from any state that already contains it
              if (state is SubmissionsSuccess) {
                displayData = state.submissions;
              } else if (state is ApproveAllLoading) {
                displayData = state.submissions;
              } else if (state is ApproveAllSuccess) {
                displayData = state.submissions;
              }

              /// ================= INITIAL LOADING =================
              /// Show loader only if no cached data exists
              if (state is SubmissionsLoading &&
                  displayData == null) {
                return const Center(
                  child: AppAnimatedLoadingIndicator(),
                );
              }

              /// ================= FAILURE STATE =================
              /// Show error only when no data is available
              if (state is SubmissionsFailure &&
                  displayData == null) {
                return const Center(
                  child: Text('Failed to load submissions'),
                );
              }

              /// ================= SAFE NULL GUARD =================
              /// Prevent building UI before data is ready
              if (displayData == null) {
                return const SizedBox.shrink();
              }

              /// Extract full submissions list
              final List<AssSubmissionModel> allList =
                  displayData.submissions;

              /// Split submissions into categories
              final gradedList = allList
                  .where((e) => e.neededReview == false)
                  .toList();

              final neddedReviewList = allList
                  .where((e) => e.neededReview == true)
                  .toList();

              return CustomScrollView(
                controller: scrollController,
                slivers: [

                  /// ================= HEADER SECTION =================
                  /// Page title + animation banner
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

                  /// ================= STATS BAR =================
                  /// Displays submitted / marked / unmarked counts
                  SliverToBoxAdapter(
                    child: AssignSubmissionsStatsBar(
                      totalSubmitted: displayData.stats.submitted,
                      totalMarked: displayData.stats.marked,
                      totalUnmarked: displayData.stats.unmarked,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),

                  /// ================= EMPTY STATE =================
                  if (allList.isEmpty)
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Lottie.asset(AppLottie.empty, width: 200),
                          const SizedBox(height: 10),
                          const Text('No submissions yet!'),
                        ],
                      ),
                    )

                  /// ================= DATA STATE =================
                  else ...[

                    /// ---------- NEEDS REVIEW SECTION ----------
                    if (neddedReviewList.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _buildSectionTitle(
                          'Needs Review',
                          Colors.orange,
                        ),
                      ),
                      _buildSubmissionSliverList(
                        list: neddedReviewList,
                      ),
                    ],

                    /// ---------- GRADED SECTION ----------
                    if (gradedList.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _buildSectionTitle(
                          'Graded',
                          Colors.green,
                        ),
                      ),
                      _buildSubmissionSliverList(
                        list: gradedList,
                      ),
                    ],

                    /// ================= PAGINATION LOADING =================
                    /// Shows loading indicator when fetching next page
                    SliverToBoxAdapter(
                      child: BlocBuilder<
                          AssignmentSubmissionCubit,
                          AssignmentSubmissionState>(
                        builder: (context, state) {
                          final cubit = context
                              .read<AssignmentSubmissionCubit>();

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
                    ),

                    /// ================= APPROVE ALL BUTTON =================
                    /// Visible only if plagiarism check is enabled
                    /// and there are submissions needing review
                    if (widget.enablePlagiarismCheck &&
                        neddedReviewList.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: SizedBox(
                              width: 180,
                              height: 45,
                              child: ApproveAllButton(
                                isLoading: state is ApproveAllLoading,
                                isSuccess: state is ApproveAllSuccess,

                                /// Trigger bulk approval action
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
                      ),
                  ],

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds section header with colored indicator bar
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 4, height: 24, color: color),
          const SizedBox(width: 12),
          Text(title, style: AppStyles.mobileBodyLargeSb),
        ],
      ),
    );
  }

  /// Builds a submission card item
  /// and handles navigation to details screen
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

            /// Navigate to submission details screen
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