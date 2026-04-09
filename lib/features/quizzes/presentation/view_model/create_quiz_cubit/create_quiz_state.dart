part of 'create_quiz_cubit.dart';

sealed class CreateQuizState {
  const CreateQuizState();
}

final class CreateQuizInitial extends CreateQuizState {}

final class CreateQuizUIUpdated extends CreateQuizState {}

final class CreateQuizLoading extends CreateQuizState {}

final class CreateQuizSuccess extends CreateQuizState {
  final String message;
  const CreateQuizSuccess(this.message);
}

final class CreateQuizFailure extends CreateQuizState {
  final String message;
  const CreateQuizFailure(this.message);
}
