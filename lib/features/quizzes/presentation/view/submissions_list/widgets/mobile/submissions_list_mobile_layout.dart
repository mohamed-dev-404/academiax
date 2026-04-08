import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

import 'package:sams_app/features/quizzes/data/model/data_models/submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/shared/submission_list_tile.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/mobile/submissions_header_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/submissions_cubit/submissions_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/widgets/shared/submissions_stats_bar.dart';

class SubmissionsListMobileLayout extends StatelessWidget {
  const SubmissionsListMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {}, //TODO: implement back navigation
          icon: const Icon(Icons.arrow_circle_left_outlined),
        ),
        title: const Text('All Submissions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SubmissionsHeaderCard(),
            const SizedBox(height: 24),

            BlocBuilder<SubmissionsCubit, SubmissionsState>(
              builder: (context, state) {
                if (state is SubmissionsLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(child: AppAnimatedLoadingIndicator()),
                  );
                } else if (state is SubmissionsFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        state.errorMessage,
                        style: AppStyles.mobileBodyLargeMd.copyWith(
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
                      .where((e) => e.status == SubmissionStatus.marked)
                      .toList();
                  unmarkedList = list
                      .where((e) => e.status == SubmissionStatus.unmarked)
                      .toList();
                  totalMarked = markedList.length;
                  totalUnmarked = unmarkedList.length;
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //* The stats overview
                      SubmissionsStatsBar(
                        totalSubmitted: totalSubmitted,
                        totalMarked: totalMarked,
                        totalUnmarked: totalUnmarked,
                      ),
                      const SizedBox(height: 32),

                      if (state is SubmissionsEmpty) ...[
                        Center(
                          child: Lottie.asset(
                            AppLottie.empty,
                            width: 250,
                            repeat: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No submissions yet!',
                          style: AppStyles.mobileBodyLargeSb.copyWith(
                            color: AppColors.primaryDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 100),
                      ] else ...[
                        //* --- UNMARKED SECTION ---
                        if (unmarkedList.isNotEmpty) ...[
                          _buildSectionTitle(
                            'Needs Review',
                            StatusColors.orangeDark,
                          ),
                          const SizedBox(height: 16),
                          _buildSubmissionsList(unmarkedList),
                          const SizedBox(height: 32),
                        ],

                        //* --- MARKED SECTION ---
                        if (markedList.isNotEmpty) ...[
                          _buildSectionTitle('Graded', StatusColors.green),
                          const SizedBox(height: 16),
                          _buildSubmissionsList(markedList),
                          const SizedBox(height: 40),
                        ],
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Extracted builder method
  Widget _buildSubmissionsList(List<SubmissionModel> submissions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: submissions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SizedBox(
          height: 110,
          child: SubmissionListTile(
            submission: submissions[index],
            maxScore: 10, // Pass your max quiz score here
            onTap: () {
              //TODO nav to Grading
            },
          ),
        );
      },
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
        Text(title, style: AppStyles.mobileBodyLargeSb),
      ],
    );
  }
}
