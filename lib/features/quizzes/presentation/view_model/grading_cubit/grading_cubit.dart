import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

part 'grading_state.dart';

class GradingCubit extends Cubit<GradingState> {
  final QuizRepository _repository;

  GradingCubit(this._repository) : super(GradingInitial());

  // ─── Fetch submission details ────────────────────────────────────────────
  // Currently uses mock data. Replace the body with a real API call:
  //   final result = await _repository.getSubmissionDetails(submissionId);
  //   result.fold((err) => emit(GradingFailure(err)), (data) => emit(GradingLoaded(data)));
  Future<void> loadSubmissionDetails(String submissionId) async {
    emit(GradingLoading());
    try {
      // TODO: replace with → final result = await _repository.getSubmissionDetails(submissionId);
      // Simulating network delay for realistic UX testing
      await Future.delayed(const Duration(milliseconds: 600));
      emit(GradingLoaded(mockSubmissionDetails));
    } catch (e) {
      emit(GradingFailure(e.toString()));
    }
  }

  // ─── Grade a single written question ────────────────────────────────────
  // Currently a stub that updates local state optimistically.
  // Replace the body with a real API call:
  //   final result = await _repository.gradeSubmissionQuestion(submissionId, questionId, {'score': score});
  Future<void> gradeQuestion({
    required String submissionId,
    required String questionId,
    required num score,
  }) async {
    // 1. Grab current questions list from state (only valid if already loaded)
    final currentState = state;
    if (currentState is! GradingLoaded) return;

    final currentQuestions = currentState.questions;

    // 2. Emit saving state so the specific row shows a loading indicator
    emit(GradingQuestionSaving(
      questions: currentQuestions,
      savingQuestionId: questionId,
    ));

    try {
      // TODO: replace with → await _repository.gradeSubmissionQuestion(submissionId, questionId, {'score': score});
      await Future.delayed(const Duration(milliseconds: 800));

      // 3. Optimistically update the local list so the UI refreshes instantly
      final updatedQuestions = currentQuestions.map((q) {
        if (q.id != questionId) return q;
        return StudentSubmissionModel(
          id: q.id,
          text: q.text,
          questionType: q.questionType,
          timeLimit: q.timeLimit,
          points: q.points,
          earnedPoints: score.toInt(),
          isCorrect: score > 0,
          isGraded: true,
          writtenAnswer: q.writtenAnswer,
          options: q.options,
          selectedOptionId: q.selectedOptionId,
        );
      }).toList();

      emit(GradingLoaded(updatedQuestions));
    } catch (e) {
      // On failure — restore the list so the screen is still usable
      emit(GradingLoaded(currentQuestions));
      // Re-emit failure so the listener in GradeSubmissionView can show a toast
      emit(GradingFailure(e.toString()));
    }
  }
}

