import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

part 'grading_state.dart';

class GradingCubit extends Cubit<GradingState> {
  final QuizRepository _repo;
  late final String submissionId;

  GradingCubit(this._repo) : super(GradingInitial());

  // * ─── Fetch submission details ────────────────────────────────────────────
  Future<void> loadSubmissionDetails(String submissionId) async {
    this.submissionId = submissionId;

    emit(StudentSubmissionLoading());

    try {
      final result = await _repo.getStudentSubmission(submissionId);

      result.fold(
        (errorMessage) {
          emit(
            StudentSubmissionFetchingFailure(errorMessage: errorMessage),
          );
        },
        (studentSubmission) {
          emit(
            StudentSubmissionLoadedSuccessfully(
              studentSubmission: studentSubmission,
            ),
          );
        },
      );
    } catch (e) {
      emit(StudentSubmissionFetchingFailure(errorMessage: e.toString()));
    }
  }

  // * ─── Grade a single written question ────────────────────────────────────
  Future<void> gradeWrittenQuestion({
    required String questionId,
    required num score,
  }) async {
    // ? 1. Grab current questions list from state (only valid if already loaded)
    final currentState = state;
    if (currentState is! StudentSubmissionLoadedSuccessfully) return;

    final currentStudentSubmission = currentState.studentSubmission;

    // ? 2. Optimistically update the local list so the UI refreshes instantly (optimistic update not actual list yet)
    final updatedQuestions = currentStudentSubmission.map((q) {
      if (q.id != questionId) return q;
      return StudentSubmissionModel(
        id: q.id,
        text: q.text,
        questionType: q.questionType,
        timeLimit: q.timeLimit,
        points: q.points,
        earnedPoints: score, // update score locally
        isCorrect: score > 0,
        isGraded: true, // update question status locally
        writtenAnswer: q.writtenAnswer,
        options: q.options,
        selectedOptionId: q.selectedOptionId,
      );
    }).toList();

    emit(
      StudentSubmissionLoadedSuccessfully(
        studentSubmission: updatedQuestions,
      ),
    );

    try {
      final result = await _repo.gradeWrittenQuestion(
        submissionId,
        questionId,
        score,
      );

      result.fold(
        (errorMessage) {
          // Re-emit failure so the listener in GradeSubmissionView can show a toast
          emit(
            GradingQuestionSavingFailure(errorMessage: errorMessage),
          );
          // On failure — restore the list so the screen is still usable
          emit(
            StudentSubmissionLoadedSuccessfully(
              studentSubmission: currentStudentSubmission,
            ),
          );
        },
        (studentSubmission) {
          // On success emit success message
          emit(
            GradingQuestionSavingSuccess(
              successMessage: 'Question graded successfully',
            ),
          );
          // keep optimistic update
          emit(
            StudentSubmissionLoadedSuccessfully(
              studentSubmission: updatedQuestions,
            ),
          );
        },
      );
    } catch (e) {
      // Re-emit failure so the listener in GradeSubmissionView can show a toast
      emit(
        GradingQuestionSavingFailure(errorMessage: e.toString()),
      );
      // On failure — restore the list so the screen is still usable
      emit(
        StudentSubmissionLoadedSuccessfully(
          studentSubmission: currentStudentSubmission,
        ),
      );
    }
  }
}
