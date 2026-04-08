import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';

/// Extension to map [QuestionUIState] to UI properties.
extension QuestionUIStateExtension on QuestionUIState {
  // Navigator Dot Styling
  Color get navDotColor {
    switch (this) {
      case QuestionUIState.correct:
      case QuestionUIState.marked:
        return StatusColors.green;
      case QuestionUIState.incorrect:
        return StatusColors.red;
      case QuestionUIState.unmarked:
        return StatusColors.orange;
    }
  }

  IconData get navDotIcon {
    switch (this) {
      case QuestionUIState.correct:
      case QuestionUIState.marked:
        return Icons.check_circle_rounded;
      case QuestionUIState.incorrect:
        return Icons.cancel_rounded;
      case QuestionUIState.unmarked:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  // Question State Chip Styling
  Color get chipColor {
    switch (this) {
      case QuestionUIState.correct:
        return StatusColors.green;
      case QuestionUIState.incorrect:
        return StatusColors.red;
      case QuestionUIState.marked:
        return AppColors.primary;
      case QuestionUIState.unmarked:
        return StatusColors.orange;
    }
  }

  IconData get chipIcon {
    switch (this) {
      case QuestionUIState.correct:
        return Icons.check_circle_rounded;
      case QuestionUIState.incorrect:
        return Icons.cancel_rounded;
      case QuestionUIState.marked:
        return Icons.done_all_rounded;
      case QuestionUIState.unmarked:
        return Icons.schedule_rounded;
    }
  }

  String get chipLabel {
    switch (this) {
      case QuestionUIState.correct:
        return 'CORRECT';
      case QuestionUIState.incorrect:
        return 'INCORRECT';
      case QuestionUIState.marked:
        return 'MARKED';
      case QuestionUIState.unmarked:
        return 'PENDING';
    }
  }

  // Auto-Grade Info Card Styling
  String get autoGradeFeedbackLabel =>
      this == QuestionUIState.correct ? 'Correct Answer' : 'Wrong Answer';
  Color get autoGradeFeedbackColor =>
      this == QuestionUIState.correct ? StatusColors.green : StatusColors.red;
  IconData get autoGradeFeedbackIcon => this == QuestionUIState.correct
      ? Icons.check_circle_rounded
      : Icons.cancel_rounded;
}

/// Extension to map [StudentSubmissionModel] properties to UI parameters.
extension StudentSubmissionModelUIExtension on StudentSubmissionModel {
  // Type Badge Styling
  Color get typeBadgeColor =>
      isWritten ? AppColors.primary : AppColors.secondary;
  IconData get typeBadgeIcon =>
      isWritten ? Icons.description_outlined : Icons.fact_check_outlined;
}

/// Extension to map [OptionUIState] to UI properties.
extension OptionUIStateExtension on OptionUIState {
  Color get tileBackgroundColor {
    switch (this) {
      case OptionUIState.correctSelected:
        return StatusColors.green.withValues(alpha: 0.25);
      case OptionUIState.wrongSelected:
        return StatusColors.red.withValues(alpha: 0.2);
      case OptionUIState.correctUnselected:
        return StatusColors.green.withValues(alpha: 0.1);
      case OptionUIState.unselected:
        return AppColors.whiteLight.withValues(alpha: 0.4);
    }
  }

  Color get tileBorderColor {
    switch (this) {
      case OptionUIState.correctSelected:
      case OptionUIState.correctUnselected:
        return StatusColors.green;
      case OptionUIState.wrongSelected:
        return StatusColors.red;
      case OptionUIState.unselected:
        return AppColors.secondaryLightActive.withValues(alpha: 0.2);
    }
  }

  Color get textContentColor {
    switch (this) {
      case OptionUIState.unselected:
        return AppColors.whiteDarkActive.withValues(alpha: 0.5);
      default:
        return AppColors.primaryDark;
    }
  }

  IconData? get trailingIcon {
    switch (this) {
      case OptionUIState.correctSelected:
        return Icons.check_circle_rounded;
      case OptionUIState.wrongSelected:
        return Icons.cancel_rounded;
      case OptionUIState.correctUnselected:
        return Icons.check_circle_outline;
      case OptionUIState.unselected:
        return null;
    }
  }

  Color? get trailingIconColor {
    switch (this) {
      case OptionUIState.correctSelected:
      case OptionUIState.correctUnselected:
        return StatusColors.green;
      case OptionUIState.wrongSelected:
        return StatusColors.red;
      case OptionUIState.unselected:
        return null;
    }
  }

  bool get isBoldText =>
      this == OptionUIState.correctSelected ||
      this == OptionUIState.correctUnselected;
}
