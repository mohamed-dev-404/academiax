import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/instructor/instructor_actions_list.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/instructor/instructor_contextual_banner.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_header.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_schedule_card.dart';

class QuizDetailsWebInstructorLayout extends StatelessWidget {
  final QuizModel quiz;
  final String courseId;

  const QuizDetailsWebInstructorLayout({
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * 1. Header (Full Width for both Desktop & Tablet)
            QuizDetailsHeader(
              quiz: quiz,
              courseId: courseId,
            ),
            const SizedBox(height: 32),

            // * 2. Adaptive Content
            width > 990 ? _buildDesktopContent() : _buildTabletContent(),
          ],
        ),
      ),
    );
  }

  // * Desktop Layout (Two Columns)
  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Schedule & Banner
        Expanded(
          flex: 6,
          child: _buildMainBody(),
        ),
        const SizedBox(width: 40),
        // Right Column: Actions
        Expanded(
          flex: 4,
          child: quiz.state == QuizState.lockedDraft
              ? Center(child: Lottie.asset(AppLottie.empty))
              : _buildSideContent(),
        ),
      ],
    );
  }

  // * Tablet Layout (One Column)
  Widget _buildTabletContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainBody(),
        const SizedBox(height: 32),
        quiz.state == QuizState.lockedDraft
            ? const SizedBox()
            : _buildSideContent(),
      ],
    );
  }

  // * Content Shared between Desktop & Tablet Body
  Widget _buildMainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuizDetailsScheduleCard(quiz: quiz),
        const SizedBox(height: 32),
        InstructorContextualBanner(quiz: quiz),
      ],
    );
  }

  // * Side Panel (Actions Container)
  Widget _buildSideContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLightActive),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InstructorActionsList(
        quiz: quiz,
        courseId: courseId,
      ),
    );
  }
}
