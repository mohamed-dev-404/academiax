part of 'manage_quiz_cubit.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Manage Quiz State — Sealed hierarchy
// ──────────────────────────────────────────────────────────────────────────────

sealed class ManageQuizState {
  const ManageQuizState();
}

/// Initial state — before [ManageQuizCubit.init] is called.
final class ManageQuizInitial extends ManageQuizState {}

/// Questions are being fetched from the API (edit / view mode).
final class ManageQuizLoading extends ManageQuizState {}

/// Initial load complete. Contains the data fetched from the API (or empty for draft).
/// The UI will take this data and manage it locally.
final class ManageQuizQuestionsLoaded extends ManageQuizState {
  final List<EditableQuestionModel> questions;

  const ManageQuizQuestionsLoaded(this.questions);
}

/// An API action (add/update/delete) is in progress.
final class ManageQuizActionLoading extends ManageQuizState {}

/// An API action succeeded — transient state consumed by BlocListener.
final class ManageQuizSuccess extends ManageQuizState {
  final String message;
  const ManageQuizSuccess(this.message);
}

/// A specific API action (like deletion) succeeded and should NOT trigger a pop.
final class ManageQuizDeleteSuccess extends ManageQuizState {
  final String message;
  const ManageQuizDeleteSuccess(this.message);
}

/// An error occurred.
final class ManageQuizFailure extends ManageQuizState {
  final String message;
  const ManageQuizFailure(this.message);
}
