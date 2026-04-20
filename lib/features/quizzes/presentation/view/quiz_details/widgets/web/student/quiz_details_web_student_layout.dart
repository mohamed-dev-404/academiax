import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_header.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/stats_row.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_schedule_card.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/student/instructions_section.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/student/quiz_deadline_timer.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/student/student_action_card.dart';

class QuizDetailsWebStudentLayout extends StatelessWidget {
  final QuizModel quiz;
  final String courseId;

  const QuizDetailsWebStudentLayout({
    super.key,
    required this.quiz,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: width > 940
            ? _buildDesktopLayout(context)
            : _buildTabletLayout(context),
      ),
    );
  }

  // * 1. Desktop Layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuizDetailsHeader(
          quiz: quiz,
          courseId: courseId,
        ),
        const SizedBox(height: 32),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Left Column: Stats & Instructions
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsRow(quiz: quiz),
                  const SizedBox(height: 32),
                  _buildInstructions(),
                ],
              ),
            ),
            const SizedBox(width: 40),
            //* Right Column: Timer & Action Card
            Expanded(
              flex: 4,
              child: _buildSideContent(context),
            ),
          ],
        ),
      ],
    );
  }

  // * 2. Tablet Layout
  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuizDetailsHeader(
          quiz: quiz,
          courseId: courseId,
        ),
        const SizedBox(height: 32),
        StatsRow(quiz: quiz),
        const SizedBox(height: 32),
        _buildSideContent(context),
        const SizedBox(height: 32),
        _buildInstructions(),
      ],
    );
  }

  // * 3. Instructions Area
  Widget _buildInstructions() {
    if (quiz.state == QuizState.closed) return const SizedBox.shrink();
    return const InstructionsSection();
  }

  // * 4. Side Content Area (Timer & Action Card)
  Widget _buildSideContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (quiz.state == QuizState.available) ...[
          QuizDeadlineTimer(endTime: quiz.endTime),
          const SizedBox(height: 24),
        ],

        if (quiz.state == QuizState.upcoming) ...[
          QuizDetailsScheduleCard(quiz: quiz),
          const SizedBox(height: 24),
        ],

        StudentActionCard(
          onPressed: () {
            context.push(
              RoutesName.takeQuiz,
              extra: {
                'quizId': quiz.id,
                'quizTitle': quiz.title,
              },
            );
          },
          quiz: quiz,
        ),
      ],
    );
  }
}
