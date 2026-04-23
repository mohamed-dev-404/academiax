import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';

@immutable
sealed class AssignmentDetailsState {}

final class AssignmentDetailsInitial extends AssignmentDetailsState {}

// --- Fetch Details Section ---
final class AssignmentDetailsLoading extends AssignmentDetailsState {}

final class AssignmentDetailsSuccess extends AssignmentDetailsState {
  final AssignmentModel assignment;
  AssignmentDetailsSuccess(this.assignment);
}

final class AssignmentDetailsFailure extends AssignmentDetailsState {
  final String errMessage;
  AssignmentDetailsFailure(this.errMessage);
}

