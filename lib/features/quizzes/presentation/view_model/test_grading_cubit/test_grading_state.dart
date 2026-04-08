part of 'test_grading_cubit.dart';

abstract class TestGradingState {}

class GradingInitial extends TestGradingState {}

class StudentSubmissionsLoading extends TestGradingState {}

class StudentSubmissionsSuccess extends TestGradingState {
  final List<StudentSubmissionModel> studentSubmissions;

  StudentSubmissionsSuccess({required this.studentSubmissions});
}

class StudentSubmissionsFailure extends TestGradingState {
  final String errorMessage;

  StudentSubmissionsFailure({required this.errorMessage});
}

class GradingLoading extends TestGradingState {}

class GradingSuccess extends TestGradingState {
  final String successMessage;

  GradingSuccess({required this.successMessage});
}

class GradingFailure extends TestGradingState {
  final String errorMessage;

  GradingFailure({required this.errorMessage});
}
