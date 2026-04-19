import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/mobile/question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/mobile/grade_error_widget_mobile.dart';

class GradeSubmissionMobileLayout extends StatelessWidget {
  const GradeSubmissionMobileLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradingCubit, GradingState>(
      builder: (context, state) {
        // ── Loading ───────────────────────────────────────────────────────
        if (state is StudentSubmissionLoading) {
          return const Scaffold(
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        // ── Data ready (or a question is being saved) ─────────────────────
        if (state is StudentSubmissionLoadedSuccessfully) {
          final questions = state.studentSubmission;

          return Scaffold(
            body: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
              itemCount: questions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return QuestionCard(
                  question: questions[index],
                  index: index,
                );
              },
            ),
          );
        }

        if (state is StudentSubmissionFetchingFailure) {
          return GradeErrorWidgetMobile(errorMessage: state.errorMessage);
        }

        // ── Initial (before first load) ───────────────────────────────────
        return const SizedBox.shrink();
      },
    );
  }
}
