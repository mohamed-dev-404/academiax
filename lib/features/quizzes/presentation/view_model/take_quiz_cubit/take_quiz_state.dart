part of 'take_quiz_cubit.dart';

abstract class TakeQuizState extends Equatable {
  const TakeQuizState();

  @override
  List<Object?> get props => [];
}

class TakeQuizInitial extends TakeQuizState {}

class TakeQuizLoading extends TakeQuizState {}

class TakeQuizFetchFailure extends TakeQuizState {
  final String message;
  const TakeQuizFetchFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TakeQuizInProgress extends TakeQuizState {
  // * --- What the UI needs to rebuild on ---

  final int currentQuestionIndex;
  final int remainingSeconds;
  final int questionTimeLimit;
  final List<QuestionModel> questions;
  final bool isSubmitting;
  final String? submitErrorMessage;

  // * --- Computed helpers ---

  bool get isLast10Seconds => remainingSeconds <= 10 && remainingSeconds > 0;
  bool get isLast15Seconds => remainingSeconds <= 15 && remainingSeconds > 10;
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  double get timeProgress =>
      questionTimeLimit > 0 ? remainingSeconds / questionTimeLimit : 0.0;

  const TakeQuizInProgress({
    required this.currentQuestionIndex,
    required this.remainingSeconds,
    required this.questionTimeLimit,
    required this.questions,
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  @override
  List<Object?> get props => [
    currentQuestionIndex,
    remainingSeconds,
    questionTimeLimit,
    questions,
    isSubmitting,
    submitErrorMessage,
  ];

  TakeQuizInProgress copyWith({
    int? currentQuestionIndex,
    int? remainingSeconds,
    int? questionTimeLimit,
    List<QuestionModel>? questions,
    bool? isSubmitting,
    String? submitErrorMessage,
  }) {
    return TakeQuizInProgress(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      questionTimeLimit: questionTimeLimit ?? this.questionTimeLimit,
      questions: questions ?? this.questions,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage ?? this.submitErrorMessage,
    );
  }
}

class TakeQuizSuccessSubmit extends TakeQuizState {}
