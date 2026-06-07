import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/assignment_submission_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/approve_all_button.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/assign_submission_states_bar.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/shared/submission_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/web/submission_empty_state.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/web/submission_section_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission/web/submission_sidebar_item.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_state.dart';

enum _SubmissionFilter { all, graded, needsReview }

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
  late ScrollController _scrollController;
  _SubmissionFilter _activeFilter = _SubmissionFilter.all;

  @override
  void initState() {
    super.initState();
    ///Scroll controller to trigger pagination.
    _scrollController = ScrollController();
    
    /// Pagination listener:
    /// When user scrolls near the bottom (within 300px),
    /// and there is more data available, we fetch the next page.
    _scrollController.addListener(() {
      final cubit = context.read<AssignmentSubmissionCubit>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
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
    _scrollController.dispose();
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
        body: Column(
          children: [
            // ══════════════════════════════════════════════════════════════
            // PAGE TITLE
            // ══════════════════════════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Center(
                child: Text(
                  'Assignment Submissions',
                  style: AppStyles.webTitleMediumSb.copyWith(
                    color: AppColors.primaryDarkHover,
                    fontSize: 22,
                  ),
                ),
              ),
            ),

            // ══════════════════════════════════════════════════════════════
            // CONSTRAINED BODY
            // ══════════════════════════════════════════════════════════════
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child:
                      BlocBuilder<
                        AssignmentSubmissionCubit,
                        AssignmentSubmissionState
                      >(
                        builder: (context, state) {
                          // ── Resolve display data across relevant states ─────
                          dynamic displayData;
                          if (state is SubmissionsSuccess) {
                            displayData = state.submissions;
                          } else if (state is ApproveAllLoading) {
                            displayData = state.submissions;
                          } else if (state is ApproveAllSuccess) {
                            displayData = state.submissions;
                          }

                          if (state is SubmissionsLoading &&
                              displayData == null) {
                            return const Center(
                              child: AppAnimatedLoadingIndicator(),
                            );
                          }

                          if (state is SubmissionsFailure &&
                              displayData == null) {
                            return const Center(
                              child: Text('Failed to load submissions'),
                            );
                          }

                          if (displayData == null) {
                            return const SizedBox.shrink();
                          }

                          // ── Categorise ──────────────────────────────────────
                          final List<AssSubmissionModel> allList =
                              displayData.submissions;

                          final gradedList = allList
                              .where((e) => !e.neededReview)
                              .toList();

                          final needsReviewList = allList
                              .where((e) => e.neededReview)
                              .toList();

                          // ── Apply active filter ─────────────────────────────
                          final visibleGraded =
                              _activeFilter == _SubmissionFilter.needsReview
                              ? <AssSubmissionModel>[]
                              : gradedList;

                          final visibleReview =
                              _activeFilter == _SubmissionFilter.graded
                              ? <AssSubmissionModel>[]
                              : needsReviewList;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Stats bar ─────────────────────────────────
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 42,
                                ),
                                child: AssignSubmissionsStatsBar(
                                  totalSubmitted: displayData.stats.submitted,
                                  totalMarked: displayData.stats.marked,
                                  totalUnmarked: displayData.stats.unmarked,
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 42),
                                child: Divider(height: 1, thickness: 0.5),
                              ),

                              // ── Sidebar + main panel ───────────────────────
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final horizontalPadding =
                                        constraints.maxWidth < 900
                                        ? 24.0
                                        : 42.0;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Sidebar
                                          Flexible(
                                            flex: 2,
                                            child: _buildSidebar(
                                              allCount: allList.length,
                                              gradedCount: gradedList.length,
                                              reviewCount:
                                                  needsReviewList.length,
                                            ),
                                          ),

                                          const VerticalDivider(
                                            width: 1,
                                            thickness: 0.5,
                                          ),

                                          // Main panel
                                          Flexible(
                                            flex: 5,
                                            child: _buildMainPanel(
                                              context: context,
                                              state: state,
                                              allList: allList,
                                              visibleGraded: visibleGraded,
                                              visibleReview: visibleReview,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SIDEBAR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSidebar({
    required int allCount,
    required int gradedCount,
    required int reviewCount,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubmissionSidebarItem(
            icon: Icons.format_list_bulleted_rounded,
            label: 'All submissions',
            isActive: _activeFilter == _SubmissionFilter.all,
            onTap: () => setState(() => _activeFilter = _SubmissionFilter.all),
          ),
          const SizedBox(height: 8),
          SubmissionSidebarItem(
            icon: Icons.check_circle_outline_rounded,
            label: 'Graded',
            isActive: _activeFilter == _SubmissionFilter.graded,
            onTap: () =>
                setState(() => _activeFilter = _SubmissionFilter.graded),
          ),
          const SizedBox(height: 8),
          SubmissionSidebarItem(
            icon: Icons.error_outline_rounded,
            label: 'Needs review',
            isActive: _activeFilter == _SubmissionFilter.needsReview,
            onTap: () =>
                setState(() => _activeFilter = _SubmissionFilter.needsReview),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN PANEL
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMainPanel({
    required BuildContext context,
    required AssignmentSubmissionState state,
    required List<AssSubmissionModel> allList,
    required List<AssSubmissionModel> visibleGraded,
    required List<AssSubmissionModel> visibleReview,
  }) {
    // ── Determine empty-state message based on active filter ───────────────
    if (_activeFilter == _SubmissionFilter.all && allList.isEmpty) {
      return const SubmissionEmptyState(message: 'No submissions yet!');
    }

    if (_activeFilter == _SubmissionFilter.graded && visibleGraded.isEmpty) {
      return const SubmissionEmptyState(message: 'No graded submissions yet!');
    }

    if (_activeFilter == _SubmissionFilter.needsReview &&
        visibleReview.isEmpty) {
      return const SubmissionEmptyState(
        message: 'No submissions need review!',
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Needs review section ───────────────────────────────────────
          if (visibleReview.isNotEmpty) ...[
            const SubmissionSectionHeader(
              label: 'Needs review',
              dotColor: Color(0xFFBA7517),
            ),
            const SizedBox(height: 12),
            _buildCardGrid(context, visibleReview, isGraded: false),
            const SizedBox(height: 24),
          ],

          // ── Graded section ─────────────────────────────────────────────
          if (visibleGraded.isNotEmpty) ...[
            const SubmissionSectionHeader(
              label: 'Graded',
              dotColor: Color(0xFF3B6D11),
            ),
            const SizedBox(height: 12),
            _buildCardGrid(context, visibleGraded, isGraded: true),
            const SizedBox(height: 24),
          ],

          // ── Pagination loader ──────────────────────────────────────────
          BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
            builder: (context, state) {
              final cubit = context.read<AssignmentSubmissionCubit>();
              if (cubit.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: AppAnimatedLoadingIndicator()),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // ── Approve all button ─────────────────────────────────────────
          if (widget.enablePlagiarismCheck && visibleReview.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 180,
                  height: 45,
                  child: ApproveAllButton(
                    isLoading: state is ApproveAllLoading,
                    isSuccess: state is ApproveAllSuccess,
                    onTap: () {
                      context
                          .read<AssignmentSubmissionCubit>()
                          .approveAllSubmissions(
                            assignmentId: widget.assignmentId,
                          );
                    },
                  ),
                ),
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CARD GRID
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCardGrid(
    BuildContext context,
    List<AssSubmissionModel> items, {
    required bool isGraded,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((e) {
        return SubmissionCard(
          isGraded: isGraded,
          studentName: e.studentInfo.name ?? '',
          academicId: e.studentInfo.academicId ?? '',
          formattedTime: e.formattedTime,
          displayScore: e.earnedPoints.toString(),
          maxScore: e.points.toString(),
          onTap: () {
            context.push(
              RoutesName.submissionDetails,
              extra: {
                'submissionId': e.id,
                'courseId': '',
              },
            );
          },
        );
      }).toList(),
    );
  }
}
