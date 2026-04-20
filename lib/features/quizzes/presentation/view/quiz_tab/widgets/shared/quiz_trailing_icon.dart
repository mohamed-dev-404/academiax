import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

class QuizTrailingIcon extends StatelessWidget {
  final QuizState state;

  const QuizTrailingIcon({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.bounceIn,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: _getTrailingIconWidget(),
      ),
    );
  }

  Widget _getTrailingIconWidget() {
    return switch (state) {
      //! --- Student States (Untouched Logic) ---
      QuizState.available => Container(
        key: const ValueKey('active'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.whiteLight,
              AppColors.primaryLightActive.withValues(alpha: 0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryActive.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primaryActive,
            size: 14,
          ),
        ),
      ),

      QuizState.upcoming => Container(
        key: const ValueKey('upcoming'),
        decoration: BoxDecoration(
          color: StatusColors.orangeLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: StatusColors.orange.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.lock_rounded,
            color: StatusColors.orangeDark,
            size: 16,
          ),
        ),
      ),

      QuizState.closed => Container(
        key: const ValueKey('ended'),
        decoration: BoxDecoration(
          color: AppColors.whiteHover.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_circle_rounded,
            color: AppColors.whiteDark.withValues(alpha: 0.8),
            size: 18,
          ),
        ),
      ),

      //! --- Instructor States ---
      QuizState.draft => Container(
        key: const ValueKey('draft'),
        decoration: BoxDecoration(
          color: AppColors.whiteHover,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.whiteDark.withValues(alpha: 0.3)),
        ),
        child: const Center(
          child: Icon(
            Icons.edit_rounded,
            color: AppColors.whiteDarkActive,
            size: 16,
          ),
        ),
      ),

      QuizState.scheduled => Container(
        key: const ValueKey('scheduled'),
        decoration: BoxDecoration(
          color: StatusColors.blueLight,
          shape: BoxShape.circle,
          border: Border.all(color: StatusColors.blue.withValues(alpha: 0.3)),
        ),
        child: const Center(
          child: Icon(
            Icons.alarm_on_rounded,
            color: StatusColors.blue,
            size: 16,
          ),
        ),
      ),

      QuizState.onGoing => Container(
        key: const ValueKey('instructor_ongoing'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.secondary.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.secondary, width: 1),
        ),
        child: const Center(
          child: Icon(
            Icons.podcasts_rounded,
            color: AppColors.secondary,
            size: 16,
          ),
        ),
      ),

      QuizState.completed => Container(
        key: const ValueKey('instructor_completed'),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.whiteLight,
              AppColors.primaryLightActive.withValues(alpha: 0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryActive.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.check_rounded,
            color: AppColors.primaryActive,
            size: 14,
          ),
        ),
      ),

      QuizState.lockedDraft => Container(
        key: const ValueKey('locked_draft'),
        decoration: const BoxDecoration(
          color: AppColors.redLightHover,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.lock_clock_rounded,
            color: StatusColors.red,
            size: 16,
          ),
        ),
      ),
    };
  }
}
