import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

class QuizCardStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color descriptionColor;

  const QuizCardStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  factory QuizCardStyle.fromState(QuizState state) {
    switch (state) {
      case QuizState.available:
        return const QuizCardStyle(
          backgroundColor: AppColors.primaryLight,
          borderColor: AppColors.primaryLightActive,
          titleColor: AppColors.primaryDarkActive,
          descriptionColor: AppColors.primaryDark,
        );
      case QuizState.upcoming:
        return QuizCardStyle(
          backgroundColor: StatusColors.orangeLight,
          borderColor: StatusColors.orange.withValues(alpha: 0.3),
          titleColor: AppColors.primaryDarkActive,
          descriptionColor: AppColors.primaryDark,
        );
      case QuizState.closed:
        return const QuizCardStyle(
          backgroundColor: AppColors.white,
          borderColor: AppColors.whiteHover,
          titleColor: AppColors.whiteDarkActive,
          descriptionColor: AppColors.whiteDark,
        );

      case QuizState.draft:
        return QuizCardStyle(
          backgroundColor: AppColors.whiteHover.withValues(alpha: 0.4),
          borderColor: AppColors.whiteDark.withValues(alpha: 0.2),
          titleColor: AppColors.whiteDarkActive,
          descriptionColor: AppColors.whiteDark,
        );

      case QuizState.scheduled:
        return QuizCardStyle(
          backgroundColor:
              StatusColors.blueLight, // Professional blue for scheduling
          borderColor: StatusColors.blue.withValues(alpha: 0.3),
          titleColor: StatusColors.blueDark,
          descriptionColor: AppColors.primaryDark,
        );

      case QuizState.onGoing:
        return QuizCardStyle(
          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
          borderColor: StatusColors.green.withValues(alpha: 0.3),
          titleColor: StatusColors.greenDark,
          descriptionColor: StatusColors.greenDark.withValues(alpha: 0.8),
        );
      case QuizState.completed:
        return const QuizCardStyle(
          backgroundColor: AppColors.primaryLight,
          borderColor: AppColors.primaryLightActive,
          titleColor: AppColors.primaryDarkActive,
          descriptionColor: AppColors.primaryDark,
        );

      case QuizState.lockedDraft:
        return QuizCardStyle(
          backgroundColor: AppColors.redLightHover.withValues(alpha: 0.5),
          borderColor: StatusColors.red.withValues(alpha: 0.2),
          titleColor: StatusColors.redDark,
          descriptionColor: AppColors.primaryDark,
        );
    }
  }
}
