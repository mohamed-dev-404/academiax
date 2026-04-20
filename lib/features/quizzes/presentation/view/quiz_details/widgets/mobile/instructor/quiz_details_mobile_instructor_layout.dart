import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/instructor/instructor_actions_list.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/instructor/instructor_contextual_banner.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_header.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_schedule_card.dart';

class QuizDetailsMobileInstructorLayout extends StatelessWidget {
  final QuizModel quiz;
  final String courseId;

  const QuizDetailsMobileInstructorLayout({
    super.key,
    required this.quiz,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Dynamic Header Section
            QuizDetailsHeader(
              quiz: quiz,
              courseId: courseId,
            ),

            //* Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuizDetailsScheduleCard(quiz: quiz),
                  const SizedBox(height: 24),

                  InstructorContextualBanner(quiz: quiz),
                  const SizedBox(height: 24),

                  InstructorActionsList(
                    quiz: quiz,
                    courseId: courseId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
