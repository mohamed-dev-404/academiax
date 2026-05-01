import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/base_response.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/all_submissions_model.dart';
import 'package:sams_app/features/assignments/data/model/get_submission_details/submission_details_model.dart';

@immutable
sealed class AssignmentSubmissionState {}

/// Initial
final class AssignmentSubmissionInitial extends AssignmentSubmissionState {}

// =================  GET ALL SUBMISSIONS =================

final class SubmissionsLoading extends AssignmentSubmissionState {}

final class SubmissionsSuccess extends AssignmentSubmissionState {
  final AllSubmissionsModel submissions;

  SubmissionsSuccess(this.submissions);
}

final class SubmissionsFailure extends AssignmentSubmissionState {
  final String errMessage;

  SubmissionsFailure(this.errMessage);
}

// ================= SUBMISSION DETAILS =================

sealed class SubmissionDetailsState extends AssignmentSubmissionState {}

final class SubmissionDetailsLoading extends SubmissionDetailsState {}

final class SubmissionDetailsSuccess extends SubmissionDetailsState {
  final SubmissionDetailsModel details;

  SubmissionDetailsSuccess(this.details);
}

final class SubmissionDetailsFailure extends SubmissionDetailsState {
  final String errMessage;

  SubmissionDetailsFailure(this.errMessage);
}

// =================  GRADE SUBMISSION =================

sealed class GradeSubmissionState extends AssignmentSubmissionState {}

final class GradeSubmissionLoading extends GradeSubmissionState {}

final class GradeSubmissionSuccess extends GradeSubmissionState {
  final BaseResponse response;

  GradeSubmissionSuccess(this.response);
}

final class GradeSubmissionFailure extends GradeSubmissionState {
  final String errMessage;

  GradeSubmissionFailure(this.errMessage);
}

// =================  APPROVE ALL =================

sealed class ApproveAllState extends AssignmentSubmissionState {}

final class ApproveAllLoading extends ApproveAllState {
   final AllSubmissionsModel? submissions;

  ApproveAllLoading({this.submissions});
}

final class ApproveAllSuccess extends ApproveAllState {
  final BaseResponse response;
final AllSubmissionsModel submissions; 

  ApproveAllSuccess({required this.response, required this.submissions});
}

final class ApproveAllFailure extends ApproveAllState {
  final String errMessage;

  ApproveAllFailure(this.errMessage);
}