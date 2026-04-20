import 'package:flutter/material.dart';

enum QuizActionType {
  /// Opens QuizFormScreen in Edit mode with the quiz pre-populated.
  editQuiz,
  addQuestions,
  manageQuestions,
  viewQuestions,
  viewSubmissions,
}

class QuizActionUIHelper {
  // Returns the title based on the action type
  static String getTitle(QuizActionType type) {
    switch (type) {
      case QuizActionType.editQuiz:
        return 'Edit Quiz';
      case QuizActionType.addQuestions:
        return 'Add Questions';
      case QuizActionType.manageQuestions:
        return 'Manage Questions';
      case QuizActionType.viewQuestions:
        return 'View Questions';
      case QuizActionType.viewSubmissions:
        return 'Submissions';
    }
  }

  // Returns the subtitle based on the action type
  static String getSubtitle(QuizActionType type) {
    switch (type) {
      case QuizActionType.editQuiz:
        return 'Edit quiz title, description, start time or duration';
      case QuizActionType.addQuestions:
        return 'Create content to publish the quiz';
      case QuizActionType.manageQuestions:
        return 'Review or edit questions before it starts';
      case QuizActionType.viewQuestions:
        return 'Browse quiz content and correct answers';
      case QuizActionType.viewSubmissions:
        return 'View grades and review students answers';
    }
  }

  // Returns the icon based on the action type
  static IconData getIcon(QuizActionType type) {
    switch (type) {
      case QuizActionType.editQuiz:
        return Icons.edit_rounded;
      case QuizActionType.addQuestions:
        return Icons.post_add_rounded;
      case QuizActionType.manageQuestions:
        return Icons.edit_note_rounded;
      case QuizActionType.viewQuestions:
        return Icons.quiz_outlined;
      case QuizActionType.viewSubmissions:
        return Icons.analytics_outlined;
    }
  }
}
