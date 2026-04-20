part of 'create_quiz_cubit.dart';

sealed class CreateQuizState {
  const CreateQuizState();
}

// ── Generic UI ──────────────────────────────────────────────────────────────

/// Emitted once on [init] and after every local field change
/// (classwork selection, date/time pick) so the form can rebuild.
final class CreateQuizInitial extends CreateQuizState {}

final class CreateQuizUIUpdated extends CreateQuizState {}

// ── Submit Quiz ─────────────────────────────────────────────────────────────

final class CreateQuizLoading extends CreateQuizState {}

final class CreateQuizSuccess extends CreateQuizState {
  final String message;
  const CreateQuizSuccess(this.message);
}

final class CreateQuizFailure extends CreateQuizState {
  final String message;
  const CreateQuizFailure(this.message);
}

// ── Create Classwork ────────────────────────────────────────────────────────
// Emitted when the user creates a new classwork item from the picker dialog.

final class CreateClassworkLoading extends CreateQuizState {}

final class CreateClassworkSuccess extends CreateQuizState {
  final String message;
  const CreateClassworkSuccess(this.message);
}

final class CreateClassworkFailure extends CreateQuizState {
  final String message;
  const CreateClassworkFailure(this.message);
}

// ── Fetch Available Classworks ──────────────────────────────────────────────
// Used exclusively inside the classwork picker dialog / bottom-sheet.

final class AvailableClassworksLoading extends CreateQuizState {}

final class AvailableClassworksLoaded extends CreateQuizState {
  final List<ClassworkItemModel> classworks;
  const AvailableClassworksLoaded(this.classworks);
}

final class AvailableClassworksFailure extends CreateQuizState {
  final String message;
  const AvailableClassworksFailure(this.message);
}
