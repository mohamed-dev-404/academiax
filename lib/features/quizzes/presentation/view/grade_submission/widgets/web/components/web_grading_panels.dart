import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/grading_action_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/question_detail_panel.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/widgets/web/components/question_navigator_panel.dart';

class WebGradingPanels extends StatefulWidget {
  final List<StudentSubmissionModel> questions;
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
  late final PageController _pageController;
  static const _bgColor = Color(0xFFF4F6F9);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth(context);

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
          if (width > 980)
            QuestionNavigatorPanel(
              questions: widget.questions,
              selectedIndex: _selectedIndex,
              onSelect: (i) {
                setState(() => _selectedIndex = i);
                _pageController.jumpToPage(i);
              },
            ),

          // ── Center Panel: Question Detail ───────────────────────
          Expanded(
            child: QuestionDetailPanel(
              questions: widget.questions,
              selectedIndex: _selectedIndex,
              pageController: _pageController,
              onPageChanged: (i) => setState(() => _selectedIndex = i),
              onPrev: _selectedIndex > 0
                  ? () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutQuad,
                    )
                  : null,
              onNext: _selectedIndex < widget.questions.length - 1
                  ? () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutQuad,
                    )
                  : null,
              onJump: (i) => _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              ),
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
