import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'dart:developer';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_form/quiz_form_args.dart';
import 'quiz_action_type.dart';

class InstructorActionHandler {
  // Main execution method
  static void execute({
    required BuildContext context,
    required QuizActionType action,
    required QuizModel quiz,
  }) {
    switch (action) {
      case QuizActionType.editQuiz:
        _navigateToEditQuiz(context, quiz);
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
  /// as [QuizFormArgs.initialData] so every field is pre-populated.
  static void _navigateToEditQuiz(BuildContext context, QuizModel quiz) {
    final courseId = getCourseId(context);
    log('Navigating to EditQuiz: ${quiz.id}');
    context.pushNamed(
      RoutesName.createQuiz,
      pathParameters: {'courseId': courseId},
      extra: QuizFormArgs(
        courseId: courseId,
        isEditMode: true,
        initialData: quiz,
      ),
    );
  }

  static void _navigateToAddQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to Add Questions for quiz: ${quiz.id}');
    // TODO: Add GoRouter or Navigator logic here
  }

  static void _navigateToManageQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to Manage Questions for quiz: ${quiz.id}');
  }

  static void _navigateToViewQuestions(BuildContext context, QuizModel quiz) {
    log('Navigating to View Questions for quiz: ${quiz.id}');
  }

  static void _navigateToSubmissions(BuildContext context, QuizModel quiz) {
    kIsWeb
        ? context.goNamed(
            RoutesName.submissionsList,
            pathParameters: {
              'courseId': getCourseId(
                context,
              ), // Required by the parent ShellRoute/Tab
              'quizId': quiz.id, // Required by the quizDetails route
            },
          )
        : context.pushNamed(
            RoutesName.submissionsList,
            pathParameters: {
              'courseId': getCourseId(
                context,
              ), // Required by the parent ShellRoute/Tab
              'quizId': quiz.id, // Required by the quizDetails route
            },
          );
    log('Navigating to Submissions for quiz: ${quiz.id}');
  }

  static String getCourseId(BuildContext context) =>
      GoRouterState.of(context).pathParameters['courseId'] ?? '';
}
