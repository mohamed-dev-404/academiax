import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

part 'test_grading_state.dart';

class TestGradingCubit extends Cubit<TestGradingState> {
  final QuizRepository _repo;
  late final String submissionId;

  TestGradingCubit(this._repo) : super(GradingInitial());

  // * Get student submissions request
  Future<void> getStudentSubmissions(String submissionId) async {
    this.submissionId = submissionId;

    emit(StudentSubmissionsLoading());

    try {
      final result = await _repo.getStudentSubmission(submissionId);

      result.fold(
        (errorMessage) {
          emit(StudentSubmissionsFailure(errorMessage: errorMessage));
        },
        (studentSubmissions) {
          emit(
            StudentSubmissionsSuccess(studentSubmissions: studentSubmissions),
          );
        },
      );
    } catch (e) {
      emit(StudentSubmissionsFailure(errorMessage: e.toString()));
    }
  }

  // *  Grade written question  request
  Future<void> gradeWrittenQuestion(String questionId, int score) async {
    emit(GradingLoading());
    try {
      final result = await _repo.gradeWrittenQuestion(
        submissionId,
        questionId,
        score,
      );

      result.fold(
        (errorMessage) {
          emit(GradingFailure(errorMessage: errorMessage));
        },
        (successMessage) {
          emit(GradingSuccess(successMessage: successMessage));
        },
      );
    } catch (e) {
      emit(GradingFailure(errorMessage: e.toString()));
    }
  }
}
