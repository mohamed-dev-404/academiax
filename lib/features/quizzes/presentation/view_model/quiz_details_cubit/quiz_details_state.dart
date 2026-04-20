import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

abstract class QuizDetailsState {}

class QuizDetailsInitial extends QuizDetailsState {}

class QuizDetailsLoading extends QuizDetailsState {}

class QuizDetailsSuccess extends QuizDetailsState {
  final QuizModel quiz;

  QuizDetailsSuccess({required this.quiz});
}

class QuizDetailsFailure extends QuizDetailsState {
  final String errorMessage;

  QuizDetailsFailure({required this.errorMessage});
}

class QuizDetailsDeleteLoading extends QuizDetailsState {}

class QuizDetailsDeleteSuccess extends QuizDetailsState {
  final String message;

  QuizDetailsDeleteSuccess({required this.message});
}

class QuizDetailsDeleteFailure extends QuizDetailsState {
  final String errorMessage;

  QuizDetailsDeleteFailure({required this.errorMessage});
}
