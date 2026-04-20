part of 'grading_cubit.dart';

sealed class GradingState {}

// ! Initial state
class GradingInitial extends GradingState {}

// ! Fetching the full submission details from the API (loading)
class StudentSubmissionLoading extends GradingState {}

// ! Data is ready — holds the questions list to display (success fetch)
class StudentSubmissionLoadedSuccessfully extends GradingState {
  final List<StudentSubmissionModel> studentSubmission;

  StudentSubmissionLoadedSuccessfully({required this.studentSubmission});
}

// ! Any error occurred (failed fetch)
class StudentSubmissionFetchingFailure extends GradingState {
  final String errorMessage;

  StudentSubmissionFetchingFailure({required this.errorMessage});
}

// ! success save graded question
class GradingQuestionSavingSuccess extends GradingState {
  final String successMessage;

  GradingQuestionSavingSuccess({required this.successMessage});
}

// ! failed save graded question
class GradingQuestionSavingFailure extends GradingState {
  final String errorMessage;

  GradingQuestionSavingFailure({required this.errorMessage});
}
