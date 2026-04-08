import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

part 'submissions_state.dart';

class SubmissionsCubit extends Cubit<SubmissionsState> {
  final QuizRepository _repo;

  SubmissionsCubit(this._repo) : super(SubmissionsInitial());

  // * fetchAllSubmissions method
  Future<void> fetchAllSubmissions({required String quizId}) async {
    emit(SubmissionsLoading());
    try {
      final response = await _repo.getAllSubmissions(quizId);

      response.fold(
        (errorMessage) {
          emit(SubmissionsFailure(errorMessage: errorMessage));
        },
        (submissionsList) {
          if (submissionsList.isEmpty) {
            emit(SubmissionsEmpty());
          } else {
            emit(SubmissionsSuccess(submissions: submissionsList));
          }
        },
      );
    } catch (e) {
      emit(SubmissionsFailure(errorMessage: e.toString()));
    }
  }
}
