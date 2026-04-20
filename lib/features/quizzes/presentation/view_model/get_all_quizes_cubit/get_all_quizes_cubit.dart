import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'get_all_quizes_state.dart';

class GetAllQuizesCubit extends Cubit<GetAllQuizesState> {
  final QuizRepository _quizRepo;

  GetAllQuizesCubit(this._quizRepo) : super(GetAllQuizesInitial());

  /// Fetches all quizzes for a specific course
  Future<void> getCourseQuizzes({required String courseId}) async {
    emit(GetAllQuizesLoading());

    final result = await _quizRepo.getQuizzesForCourse(courseId);

    // Fold the Either result into appropriate states
    result.fold(
      (errorMessage) {
        emit(GetAllQuizesFailure(errorMessage: errorMessage));
      },
      (quizzes) {
        emit(GetAllQuizesSuccess(quizzes: quizzes));
      },
    );
  }
}
