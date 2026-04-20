import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

abstract class GetAllQuizesState {}

class GetAllQuizesInitial extends GetAllQuizesState {}

class GetAllQuizesLoading extends GetAllQuizesState {}

class GetAllQuizesSuccess extends GetAllQuizesState {
  final List<QuizModel> quizzes;

  GetAllQuizesSuccess({required this.quizzes});
}

class GetAllQuizesFailure extends GetAllQuizesState {
  final String errorMessage;

  GetAllQuizesFailure({required this.errorMessage});
}