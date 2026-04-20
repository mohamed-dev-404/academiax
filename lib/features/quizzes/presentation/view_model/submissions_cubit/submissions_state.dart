part of 'submissions_cubit.dart';

abstract class SubmissionsState {}

class SubmissionsInitial extends SubmissionsState {}

class SubmissionsLoading extends SubmissionsState {}

class SubmissionsEmpty extends SubmissionsState {}

class SubmissionsSuccess extends SubmissionsState {
  final List<SubmissionModel> submissions;

  SubmissionsSuccess({required this.submissions});
}

class SubmissionsFailure extends SubmissionsState {
  final String errorMessage;

  SubmissionsFailure({required this.errorMessage});
}
