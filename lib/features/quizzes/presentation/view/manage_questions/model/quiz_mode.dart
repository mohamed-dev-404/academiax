/// Determines the behaviour & editability of the ManageQuestionsView.
///
/// Derived from [QuizState] at the call-site ([InstructorActionHandler]):
/// - [QuizState.draft]     → [QuizMode.draft]
/// - [QuizState.scheduled] → [QuizMode.edit]
/// - [QuizState.onGoing] / [QuizState.completed] → [QuizMode.view]
enum QuizMode {
  /// Draft quiz — start with an empty list, add questions sequentially.
  draft,

  /// Scheduled quiz — full edit access to existing questions.
  edit,

  /// Ongoing/Completed quiz — read-only view of all questions.
  view,
}
