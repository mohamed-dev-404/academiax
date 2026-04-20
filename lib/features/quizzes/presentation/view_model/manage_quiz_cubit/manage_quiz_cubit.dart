import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/add_question/add_questions_request_body.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';

part 'manage_quiz_state.dart';

/// The Cubit is now strictly responsible for Business Logic and API calls.
/// It contains ZERO UI logic or data state.
///
/// It only holds identifiers needed for API operations. Data manipulation
/// is managed entirely by the Presentation layer (View).
class ManageQuizCubit extends Cubit<ManageQuizState> {
  final QuizRepository _repository;

  ManageQuizCubit(this._repository) : super(ManageQuizInitial());

  late String _quizId;
  late QuizMode _mode;

  // ──────────────────────────────────────────────────────────────────────────
  // Initialization
  // ──────────────────────────────────────────────────────────────────────────

  /// Entry point called by the router after the Cubit is created.
  Future<void> init(ManageQuestionsArgs args) async {
    _quizId = args.quizId;
    _mode = args.mode;

    if (_mode == QuizMode.draft) {
      // Pass an empty list directly to the UI
      emit(const ManageQuizQuestionsLoaded([]));
    } else {
      await _fetchQuestions();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // API Fetch
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> _fetchQuestions() async {
    emit(ManageQuizLoading());

    final result = await _repository.getQuizQuestions(_quizId);
    result.fold(
      (error) => emit(ManageQuizFailure(error)),
      (questions) {
        final editableQuestions = questions
            .map((q) => EditableQuestionModel.fromServer(q))
            .toList();
        emit(ManageQuizQuestionsLoaded(editableQuestions));
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // API Submission (Receives current questions directly from the View)
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> submitQuestions(
    List<EditableQuestionModel> viewQuestions,
  ) async {
    if (viewQuestions.isEmpty) return;

    emit(ManageQuizActionLoading());

    try {
      if (_mode == QuizMode.draft) {
        // ─── Batch Add (POST) ───
        final body = AddQuestionsRequestBody(
          questions: viewQuestions.map((q) => q.toDto()).toList(),
        );
        final result = await _repository.addQuestion(_quizId, body.toJson());

        result.fold(
          (error) => emit(ManageQuizFailure(error)),
          (_) async {
            emit(const ManageQuizSuccess('Questions added successfully!'));
            // Refresh from server to get the real IDs for subsequent edits
            await _fetchQuestions();
            emit(ManageQuizQuestionsLoaded(viewQuestions));
          },
        );
      } else if (_mode == QuizMode.edit) {
        // ─── Sequential Updates (PATCH) & Batch Add (POST) ───
        final newQuestions = viewQuestions.where((q) => q.isNew).toList();
        final existingQuestions = viewQuestions.where((q) => !q.isNew).toList();

        for (final question in existingQuestions) {
          final dto = question.toDto();
          final result = await _repository.updateQuestion(
            question.serverId!,
            dto.toJson(),
          );
          final failed = result.fold<bool>(
            (error) {
              emit(ManageQuizFailure(error));
              return true;
            },
            (_) => false,
          );
          if (failed) return;
        }

        if (newQuestions.isNotEmpty) {
          final body = AddQuestionsRequestBody(
            questions: newQuestions.map((q) => q.toDto()).toList(),
          );
          final result = await _repository.addQuestion(
            _quizId,
            body.toJson(),
          );
          final failed = result.fold<bool>(
            (error) {
              emit(ManageQuizFailure(error));
              return true;
            },
            (_) => false,
          );
          if (failed) return;
        }

        emit(const ManageQuizSuccess('Changes saved successfully!'));
        await _fetchQuestions();
        emit(ManageQuizQuestionsLoaded(viewQuestions));
      }
    } catch (e) {
      emit(ManageQuizFailure('Something went wrong: ${e.toString()}'));
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // API Deletion
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> deleteQuestionFromServer(
    String serverId,
    List<EditableQuestionModel> viewQuestions,
  ) async {
    emit(ManageQuizActionLoading());

    try {
      final result = await _repository.deleteQuestion(serverId);
      result.fold(
        (error) {
          emit(ManageQuizFailure(error));
        },
        (_) {
          emit(const ManageQuizDeleteSuccess('Question deleted.'));
          // Let the UI know so it can potentially sync, though UI usually
          // performs local deletion first for optimistic updates.
          emit(ManageQuizQuestionsLoaded(viewQuestions));
        },
      );
    } catch (e) {
      emit(ManageQuizFailure('Failed to delete: ${e.toString()}'));
    }
  }
}
