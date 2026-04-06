import 'package:flutter/material.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/grading_action_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/question_detail_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/question_navigator_panel.dart';

class WebGradingPanels extends StatefulWidget {
  final List<SubmissionDetailsModel> questions;
  final String submissionId;

  const WebGradingPanels({
    super.key,
    required this.questions,
    required this.submissionId,
  });

  @override
  State<WebGradingPanels> createState() => _WebGradingPanelsState();
}

class _WebGradingPanelsState extends State<WebGradingPanels> {
  int _selectedIndex = 0;
  static const _bgColor = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    // Clamp selected index if questions shrink
    if (widget.questions.isNotEmpty &&
        _selectedIndex >= widget.questions.length) {
      _selectedIndex = widget.questions.length - 1;
    }

    if (widget.questions.isEmpty) {
      return const Scaffold(
        backgroundColor: _bgColor,
        body: Center(child: Text('No questions available.')),
      );
    }

    final selected = widget.questions[_selectedIndex];

    return Scaffold(
      backgroundColor: _bgColor,
      body: Row(
        children: [
          // ── Left Panel: Question Navigator ──────────────────────
          QuestionNavigatorPanel(
            questions: widget.questions,
            selectedIndex: _selectedIndex,
            onSelect: (i) => setState(() => _selectedIndex = i),
          ),

          // ── Center Panel: Question Detail ───────────────────────
          Expanded(
            child: QuestionDetailPanel(
              key: ValueKey(selected.id),
              question: selected,
              questionIndex: _selectedIndex,
              totalCount: widget.questions.length,
              onPrev: _selectedIndex > 0
                  ? () => setState(() => _selectedIndex--)
                  : null,
              onNext: _selectedIndex < widget.questions.length - 1
                  ? () => setState(() => _selectedIndex++)
                  : null,
            ),
          ),

          // ── Right Panel: Grading Action ─────────────────────────
          GradingActionPanel(
            question: selected,
            submissionId: widget.submissionId,
            questions: widget.questions,
          ),
        ],
      ),
    );
  }
}
