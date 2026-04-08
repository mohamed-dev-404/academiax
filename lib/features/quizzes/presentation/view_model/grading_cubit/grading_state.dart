part of 'grading_cubit.dart';

abstract class GradingState {}

// Initial / clean-slate
class GradingInitial extends GradingState {}

// Fetching the full submission details from the API
class GradingLoading extends GradingState {}

// Data is ready — holds the questions list to display
class GradingLoaded extends GradingState {
  final List<StudentSubmissionModel> questions;

  GradingLoaded(this.questions);
}

// A single question score is being saved (shows per-row loading indicator)
class GradingQuestionSaving extends GradingState {
  final List<StudentSubmissionModel> questions; // keeps the list visible
  final String savingQuestionId;

  GradingQuestionSaving({
    required this.questions,
    required this.savingQuestionId,
  });
}

// Any error occurred (fetching OR saving)
class GradingFailure extends GradingState {
  final String errorMessage;

  GradingFailure(this.errorMessage);
}
