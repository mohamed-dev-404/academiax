import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/web_grading_panels.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';

/// Web orchestrator for the Grade Submission screen.
///
/// Responsibilities:
///   1. Listen to [GradingCubit] state via [BlocBuilder]
///   2. Assemble the layout via [WebGradingPanels]
class GradeSubmissionWebLayout extends StatelessWidget {
  final String submissionId;

  const GradeSubmissionWebLayout({super.key, required this.submissionId});

  static const _bgColor = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradingCubit, GradingState>(
      builder: (context, state) {
        // ── Loading ───────────────────────────────────────────────────────
        if (state is GradingLoading) {
          return const Scaffold(
            backgroundColor: _bgColor,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ── Failure ───────────────────────────────────────────────────────
        if (state is GradingFailure) {
          return Scaffold(
            backgroundColor: _bgColor,
            body: Center(child: Text(state.errorMessage)),
          );
        }

        // ── Data ready ────────────────────────────────────────────────────
        if (state is GradingLoaded || state is GradingQuestionSaving) {
          final questions = state is GradingLoaded
              ? state.questions
              : (state as GradingQuestionSaving).questions;

          return WebGradingPanels(
            questions: questions,
            submissionId: submissionId,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
