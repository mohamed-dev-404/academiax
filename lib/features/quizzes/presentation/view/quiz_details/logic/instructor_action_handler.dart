import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'dart:developer';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'quiz_action_type.dart';

class InstructorActionHandler {
  // Main execution method
  static void execute({
    required BuildContext context,
    required QuizActionType action,
    required QuizModel quiz,
    required String courseId,
  }) {
    switch (action) {
      case QuizActionType.editQuiz:
        _navigateToEditQuiz(context, quiz, courseId);
        break;
      case QuizActionType.addQuestions:
        _navigateToAddQuestions(context, quiz);
        break;
      case QuizActionType.manageQuestions:
        _navigateToManageQuestions(context, quiz);
        break;
      case QuizActionType.viewQuestions:
        _navigateToViewQuestions(context, quiz);
        break;
      case QuizActionType.viewSubmissions:
        _navigateToSubmissions(context, quiz);
        break;
    }
  }

  // Navigation Logic

  /// Navigates to [QuizFormScreen] in Edit mode, passing the full [QuizModel]
  /// as [CreateQuizFormArgs.initialData] so every field is pre-populated.
  static void _navigateToEditQuiz(
    BuildContext context,
    QuizModel quiz,
    String courseId,
  ) {
    //final courseId = getCourseId(context);
    log('Navigating to EditQuiz: ${quiz.id}');
    context.push(
      RoutesName.createQuiz,
      extra: CreateQuizFormArgs(
        courseId: courseId,
        isEditMode: true,
        initialData: quiz,
      ),
    );
  }

  static void _navigateToAddQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to Add Questions for quiz: ${quiz.id}');
    context.push(
      RoutesName.manageQuestions,
      extra: ManageQuestionsArgs(
        quizId: quiz.id,
        mode: QuizMode.draft,
        quizTitle: quiz.title,
      ),
    );
  }

  static void _navigateToManageQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to Manage Questions for quiz: ${quiz.id}');
    context.push(
      RoutesName.manageQuestions,
      extra: ManageQuestionsArgs(
        quizId: quiz.id,
        mode: QuizMode.edit,
        quizTitle: quiz.title,
      ),
    );
  }

  static void _navigateToViewQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to View Questions for quiz: ${quiz.id}');
    context.push(
      RoutesName.manageQuestions,
      extra: ManageQuestionsArgs(
        quizId: quiz.id,
        mode: QuizMode.view,
        quizTitle: quiz.title,
      ),
    );
  }

  static void _navigateToSubmissions(BuildContext context, QuizModel quiz) {
    log('Navigating to Submissions for quiz: ${quiz.id}');
    context.push(
      RoutesName.submissionsList,
      extra: {'quizId': quiz.id, 'quizTitle': quiz.title},
    );
  }
}
