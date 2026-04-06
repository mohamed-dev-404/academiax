import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/grading_action_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/question_detail_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/question_navigator_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';

/// Web orchestrator for the Grade Submission screen.
///
/// Responsibilities:
///   1. Listen to [GradingCubit] state via [BlocBuilder]
///   2. Manage the selected question index (local state)
///   3. Assemble the 3-panel layout: Navigator | Detail | Grading
///
/// All panel rendering is delegated to focused component widgets.
class GradeSubmissionWebLayout extends StatefulWidget {
  final String submissionId;

  const GradeSubmissionWebLayout({super.key, required this.submissionId});

  @override
  State<GradeSubmissionWebLayout> createState() =>
      _GradeSubmissionWebLayoutState();
}

class _GradeSubmissionWebLayoutState extends State<GradeSubmissionWebLayout> {
  int _selectedIndex = 0;

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

          // Clamp selected index if questions shrink
          if (_selectedIndex >= questions.length) {
            _selectedIndex = questions.length - 1;
          }

          final selected = questions[_selectedIndex];

          return Scaffold(
            backgroundColor: _bgColor,
            body: Row(
              children: [
                // ── Left Panel: Question Navigator ──────────────────────
                QuestionNavigatorPanel(
                  questions: questions,
                  selectedIndex: _selectedIndex,
                  onSelect: (i) => setState(() => _selectedIndex = i),
                ),

                // ── Center Panel: Question Detail ───────────────────────
                Expanded(
                  child: QuestionDetailPanel(
                    key: ValueKey(selected.id),
                    question: selected,
                    questionIndex: _selectedIndex,
                    totalCount: questions.length,
                    onPrev: _selectedIndex > 0
                        ? () => setState(() => _selectedIndex--)
                        : null,
                    onNext: _selectedIndex < questions.length - 1
                        ? () => setState(() => _selectedIndex++)
                        : null,
                  ),
                ),

                // ── Right Panel: Grading Action ─────────────────────────
                GradingActionPanel(
                  question: selected,
                  submissionId: widget.submissionId,
                  questions: questions,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
