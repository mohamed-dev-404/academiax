import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/submissions_cubit/submissions_cubit.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/shared/submission_list_tile.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/shared/submissions_stats_bar.dart';

class SubmissionsListWebLayout extends StatelessWidget {
  const SubmissionsListWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          // Optional: Side Navigation would go here
          Expanded(
            child: Center(
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
                            // Header
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                children: [
                                  Lottie.asset(
                                    AppLottie.quizSubmissions,
                                    width: 250,
                                  ),
                                  Text(
                                    'Submissions Overview',
                                    style: AppStyles.mobileBodyXXlargeMd
                                        .copyWith(
                                          color: AppColors.primaryDark,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            BlocBuilder<SubmissionsCubit, SubmissionsState>(
                              builder: (context, state) {
                                if (state is SubmissionsLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50.0),
                                    child: Center(
                                      child: AppAnimatedLoadingIndicator(),
                                    ),
                                  );
                                } else if (state is SubmissionsFailure) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Text(
                                        state.errorMessage,
                                        style: AppStyles.mobileBodyLargeMd
                                            .copyWith(
                                              color: AppColors.red,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }

                                int totalSubmitted = 0;
                                int totalMarked = 0;
                                int totalUnmarked = 0;
                                List<SubmissionModel> markedList = [];
                                List<SubmissionModel> unmarkedList = [];

                                if (state is SubmissionsSuccess) {
                                  final list = state.submissions;
                                  totalSubmitted = list.length;
                                  markedList = list
                                      .where(
                                        (e) =>
                                            e.status == SubmissionStatus.marked,
                                      )
                                      .toList();
                                  unmarkedList = list
                                      .where(
                                        (e) =>
                                            e.status ==
                                            SubmissionStatus.unmarked,
                                      )
                                      .toList();
                                  totalMarked = markedList.length;
                                  totalUnmarked = unmarkedList.length;
                                }

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SubmissionsStatsBar(
                                      totalSubmitted: totalSubmitted,
                                      totalMarked: totalMarked,
                                      totalUnmarked: totalUnmarked,
                                    ),

                                    const SizedBox(height: 48),

                                    if (state is SubmissionsEmpty) ...[
                                      Center(
                                        child: Lottie.asset(
                                          AppLottie.empty,
                                          width: 300,
                                          repeat: true,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: Text(
                                          'No submissions yet!',
                                          style: AppStyles.mobileBodyXXlargeMd
                                              .copyWith(
                                                color: AppColors.primaryDark,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 100),
                                    ] else ...[
                                      // --- UNMARKED SECTION ---
                                      if (unmarkedList.isNotEmpty) ...[
                                        _buildSectionTitle(
                                          'Needs Immediate Review',
                                          StatusColors.orangeDark,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildResponsiveGrid(
                                          context,
                                          unmarkedList,
                                        ),
                                        const SizedBox(height: 48),
                                      ],

                                      // --- MARKED SECTION ---
                                      if (markedList.isNotEmpty) ...[
                                        _buildSectionTitle(
                                          'Graded Submissions',
                                          StatusColors.green,
                                        ),
                                        const SizedBox(height: 20),
                                        _buildResponsiveGrid(
                                          context,
                                          markedList,
                                        ),
                                      ],
                                      const SizedBox(height: 100),
                                    ],
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
          ),
        ],
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

  Widget _buildResponsiveGrid(
    BuildContext context,
    List<SubmissionModel> list,
  ) {
    double width = MediaQuery.of(context).size.width;
    // Determine column count based on available width
    int crossAxisCount = width > 1100 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 110, // Fixed height for tiles in grid
      ),
      itemBuilder: (context, index) => SubmissionListTile(
        submission: list[index],
        maxScore: 10,
        onTap: () {
          //TODO nav to Grading
        },
      ),
    );
  }
}
