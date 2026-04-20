import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/assets/app_audio.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/choice_question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/submit_quiz/quiz_answer_model.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';

part 'take_quiz_state.dart';

class TakeQuizCubit extends Cubit<TakeQuizState> {
  // * --- Dependencies ---
  final QuizRepository _repo;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasPlayedAlert = false; // to prevent playing the sound more than once

  // * --- Session-level fields (never change during the quiz, live on cubit) ---

  // Stored once when the route is created, used by submitQuiz internally.
  late final String quizId;

  // Accumulated answers. We append one entry every time we move to the next
  // question (or when auto-advance fires on time-up). The UI never needs to
  // read this list, so it stays here instead of polluting the state.
  final List<QuizAnswerModel> _answers = [];

  // Tracks the student's current input for the ACTIVE question only.
  // Cleared whenever we move to the next question.
  String? _currentSelectedOptionId;
  String? _currentWrittenAnswer;

  TakeQuizCubit(this._repo) : super(TakeQuizInitial());

  // ! ---------------------------------------------------------------------------
  // ! 1. FETCH & START
  // ! ---------------------------------------------------------------------------

  Future<void> fetchQuestionsAndStart(String id) async {
    quizId = id;

    // Show loading indicator
    emit(TakeQuizLoading());

    // Hit the API
    final result = await _repo.getQuizQuestions(quizId);

    result.fold(
      (failureMessage) {
        // Handles cases like the 400 "you have one retry" error by displaying failure layout.
        emit(TakeQuizFetchFailure(failureMessage));
      },
      (questionsList) {
        // shuffle the options for each question
        final shuffledQuestionList = questionsList.map((question) {
          if (question.questionType == ApiValues.written) {
            return question;
          }
          (question as ChoiceQuestionModel).options.shuffle();
          return question;
        }).toList();
        // shuffle the questions
        shuffledQuestionList.shuffle();

        // Success -> hand data to the timer flow and start the quiz
        _startQuiz(shuffledQuestionList);
      },
    );
  }

  void _startQuiz(List<QuestionModel> questions) {
    if (questions.isEmpty) return;

    _timer?.cancel();
    _audioPlayer.stop();
    _hasPlayedAlert = false;
    _answers.clear();
    _currentSelectedOptionId = null;
    _currentWrittenAnswer = null;

    emit(
      TakeQuizInProgress(
        currentQuestionIndex: 0,
        remainingSeconds: questions[0].timeLimit,
        questionTimeLimit: questions[0].timeLimit,
        questions: questions,
      ),
    );
    _startTimer();
  }

  // ! ---------------------------------------------------------------------------
  // ! 2. TIMER
  // ! ---------------------------------------------------------------------------

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // if the state is not TakeQuizInProgress, cancel the timer
      if (state is! TakeQuizInProgress) {
        timer.cancel();
        return;
      }

      final currentState = state as TakeQuizInProgress;
      if (currentState.remainingSeconds > 0) {
        final newTime =
            currentState.remainingSeconds - 1; // decrement the time by 1

        // Play audio exactly when hitting 10 seconds
        if (newTime == 10 && !_hasPlayedAlert) {
          _hasPlayedAlert = true;
          _play10sAlertSound();
        }

        emit(
          currentState.copyWith(remainingSeconds: newTime),
        ); // update the state with the new time
      } else {
        timer.cancel();
        _autoGoToNextQuestion();
      }
    });
  }

  // ! ---------------------------------------------------------------------------
  // ! 3. PLAY SOUNDS
  // ! ---------------------------------------------------------------------------

  Future<void> _play10sAlertSound() async {
    try {
      await _audioPlayer.play(AssetSource(AppAudio.timeAlert));
    } catch (e) {
      // Ignored: MissingPluginException happens on hot restart or web without proper reload
    }
  }

  Future<void> _playSuccessSubmitSound() async {
    try {
      await _audioPlayer.play(AssetSource(AppAudio.success));
    } catch (e) {
      // Ignored: MissingPluginException happens on hot restart or web without proper reload
    }
  }

  // ! ---------------------------------------------------------------------------
  // ! 4. NAVIGATION
  // ! ---------------------------------------------------------------------------

  /// * Called automatically when the timer reaches 0.
  void _autoGoToNextQuestion() {
    if (state is! TakeQuizInProgress) return;
    final currentState = state as TakeQuizInProgress;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      // Commit the answer for the current question before moving on
      _commitCurrentAnswer(currentState);
      _advanceToQuestion(
        currentState.currentQuestionIndex + 1,
        currentState,
      );
    } else {
      // submitQuiz() internally handles committing the very last answer.
      submitQuiz();
    }
  }

  /// * Called when the student taps "Next".
  void goToNextQuestion() {
    if (state is! TakeQuizInProgress) return;
    final currentState = state as TakeQuizInProgress;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      // Commit the answer for the current question before moving on
      _commitCurrentAnswer(currentState);
      _advanceToQuestion(
        currentState.currentQuestionIndex + 1,
        currentState,
      );
    }
  }

  /// Saves the current question's answer into [_answers] and resets tracking.
  void _commitCurrentAnswer(TakeQuizInProgress currentState) {
    final currentQuestion =
        currentState.questions[currentState.currentQuestionIndex];

    _answers.add(
      QuizAnswerModel(
        questionId: currentQuestion.id,
        selectedOptionId: _currentSelectedOptionId,
        writtenAnswer: _currentWrittenAnswer,
      ),
    );

    // Reset for the next question
    _currentSelectedOptionId = null;
    _currentWrittenAnswer = null;
  }

  /// Moves the state to [newIndex] and restarts the timer.
  void _advanceToQuestion(int newIndex, TakeQuizInProgress currentState) {
    _timer?.cancel();
    _audioPlayer.stop();
    _hasPlayedAlert = false;

    final timeLimit = currentState.questions[newIndex].timeLimit;

    emit(
      currentState.copyWith(
        currentQuestionIndex: newIndex,
        remainingSeconds: timeLimit,
        questionTimeLimit: timeLimit,
      ),
    );

    _startTimer();
  }

  // ! ---------------------------------------------------------------------------
  // ! 5. ANSWER TRACKING  (stored in cubit)
  // ! ---------------------------------------------------------------------------

  /// Called by the UI when the student picks a choice option.
  /// The questionType is 'MCQ' or 'TRUE_FALSE'.
  void saveSelectedOption(String optionId) {
    _currentSelectedOptionId = optionId;
    _currentWrittenAnswer = null; // mutually exclusive
  }

  /// Called by the UI when the student types a written answer.
  /// The questionType is 'WRITTEN'.
  void saveWrittenAnswer(String text) {
    _currentWrittenAnswer = text;
    _currentSelectedOptionId = null; // mutually exclusive
  }

  // ! ---------------------------------------------------------------------------
  // ! 6. SUBMIT
  // ! ---------------------------------------------------------------------------

  Future<void> submitQuiz() async {
    if (state is! TakeQuizInProgress) return;
    final currentState = state as TakeQuizInProgress;

    _timer?.cancel();
    _audioPlayer.stop();

    // Commit the last question's answer before submitting
    // (it won't have been committed by goToNextQuestion since it IS the last)
    _commitCurrentAnswer(currentState);

    // * 1. Turn on the loading spinner on the submit button and clear old errors
    emit(currentState.copyWith(isSubmitting: true, submitErrorMessage: null));

    // * 2. Call the API request with the accumulated answers list
    final result = await _repo.submitQuiz(quizId, _answers);

    result.fold(
      (failureMessage) {
        // Keep the student on TakeQuizInProgress so they don't lose context.
        // Turn off the spinner and show the error message.
        if (state is TakeQuizInProgress) {
          emit(
            (state as TakeQuizInProgress).copyWith(
              isSubmitting: false,
              submitErrorMessage: failureMessage,
            ),
          );
        }
      },
      (_) {
        // Success -> move to the final success state
        _playSuccessSubmitSound();
        emit(TakeQuizSuccessSubmit());
      },
    );
  }

  // ! ---------------------------------------------------------------------------
  // ! 7. DISPOSE
  // ! ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _answers.clear();
    _currentSelectedOptionId = null;
    _currentWrittenAnswer = null;
    return super.close();
  }
}
