import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';

/// A utility class containing pure UI logic, isolating standard presentation
/// mapping (switch cases and getters) from the business logic models and views.
class ManageQuestionsUiUtils {
  ManageQuestionsUiUtils._();

  // ──────────────────────────────────────────────────────────────────────────
  // Mode Configuration Header Getters
  // ──────────────────────────────────────────────────────────────────────────

  static String getHeaderTitle(QuizMode mode) {
    switch (mode) {
      case QuizMode.draft:
        return 'Add Questions';
      case QuizMode.edit:
        return 'Manage Questions';
      case QuizMode.view:
        return 'View Questions';
    }
  }



  static String getBadgeLabel(QuizMode mode) {
    switch (mode) {
      case QuizMode.draft:
        return 'DRAFT';
      case QuizMode.edit:
        return 'EDITING';
      case QuizMode.view:
        return 'READ-ONLY';
    }
  }

  static Color getBadgeColor(QuizMode mode) {
    switch (mode) {
      case QuizMode.draft:
        return StatusColors.orange;
      case QuizMode.edit:
        return AppColors.secondaryLightHover;
      case QuizMode.view:
        return Colors.white;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Question Card Getters
  // ──────────────────────────────────────────────────────────────────────────

  static String getQuestionTypeLabel(String type) {
    switch (type) {
      case ApiValues.written:
        return 'Written';
      case ApiValues.mcq:
        return 'Multiple Choice';
      case ApiValues.trueFalse:
        return 'True / False';
      default:
        return 'Unknown';
    }
  }
}
