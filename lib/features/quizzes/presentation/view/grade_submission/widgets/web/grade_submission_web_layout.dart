import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/web_grading_panels.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/grade_error_widget_web.dart';

/// Web orchestrator for the Grade Submission screen.
///
/// Responsibilities:
///   1. Listen to [GradingCubit] state via [BlocBuilder]
///   2. Assemble the layout via [WebGradingPanels]
class GradeSubmissionWebLayout extends StatelessWidget {
  const GradeSubmissionWebLayout({super.key});

  static const _bgColor = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradingCubit, GradingState>(
      builder: (context, state) {
        // ── Loading ───────────────────────────────────────────────────────
        if (state is StudentSubmissionLoading) {
          return const Scaffold(
            backgroundColor: _bgColor,
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        // ── Failure ───────────────────────────────────────────────────────
        if (state is StudentSubmissionFetchingFailure) {
          return GradeErrorWidgetWeb(errorMessage: state.errorMessage);
        }

        // ── Data ready ────────────────────────────────────────────────────
        if (state is StudentSubmissionLoadedSuccessfully) {
          final questions = state.studentSubmission;

          return WebGradingPanels(
            questions: questions,
          );
        }

        return const Scaffold(
          backgroundColor: _bgColor,
          body: Center(child: Text('Something went wrong')),
        );
      },
    );
  }
}
