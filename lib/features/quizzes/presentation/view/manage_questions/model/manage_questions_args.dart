import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';

/// A typed arguments object passed via GoRouter's [extra] parameter
/// when navigating to the [ManageQuestionsView].
///
/// Follows the same pattern as [CreateQuizFormArgs] — guaranteeing
/// type safety, self-documenting contracts, and easy extensibility.
class ManageQuestionsArgs {
  /// Required for all API calls (addQuestion, updateQuestion, deleteQuestion).
  final String quizId;

  /// Controls the UI mode of the screen (view / edit / draft).
  final QuizMode mode;

  /// Required: displayed prominently in the mode configuration header.
  final String quizTitle;

  const ManageQuestionsArgs({
    required this.quizId,
    required this.mode,
    required this.quizTitle,
  });
}
