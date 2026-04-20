import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

class QuizCardImage extends StatelessWidget {
  final QuizState state;

  const QuizCardImage({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Determine background and border colors using a switch expression
    final (Color bgColor, Color borderColor) = switch (state) {
      //! --- Student States (Untouched Logic) ---
      QuizState.available => (
        AppColors.primaryLightActive.withValues(alpha: 0.4),
        AppColors.primary.withValues(alpha: 0.2),
      ),
      QuizState.upcoming => (
        StatusColors.orangeTransparent,
        StatusColors.orange.withValues(alpha: 0.2),
      ),
      QuizState.closed => (
        AppColors.whiteHover.withValues(alpha: 0.5),
        Colors.transparent,
      ),

      //! --- Instructor States ---
      QuizState.onGoing => (
        StatusColors.green.withValues(alpha: 0.1),
        StatusColors.green.withValues(alpha: 0.2),
      ),
      QuizState.scheduled => (
        StatusColors.blue.withValues(alpha: 0.1),
        StatusColors.blue.withValues(alpha: 0.5),
      ),
      QuizState.completed => (
        AppColors.primaryLightActive.withValues(alpha: 0.4),
        AppColors.primary.withValues(alpha: 0.2),
      ),
      QuizState.draft => (
        AppColors.whiteHover.withValues(alpha: 0.7),
        AppColors.whiteDark.withValues(alpha: 0.7),
      ),
      QuizState.lockedDraft => (
        AppColors.redLightHover.withValues(alpha: 0.6),
        StatusColors.red.withValues(alpha: 0.2),
      ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: SvgPicture.asset(
        AppImages.imagesQuizCard,
        height: 55,
        width: 55,
      ),
    );
  }
}
