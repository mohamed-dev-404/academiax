import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';

@immutable
abstract class AssignmentDetailsState {}

final class AssignmentDetailsInitial extends AssignmentDetailsState {}

// ==========================================================================
//? --- 1. Fetch Details Section ---
// ==========================================================================

final class AssignmentDetailsLoading extends AssignmentDetailsState {}

final class AssignmentDetailsSuccess extends AssignmentDetailsState {
  final AssignmentModel assignment;
  AssignmentDetailsSuccess(this.assignment);
}

final class AssignmentDetailsFailure extends AssignmentDetailsState {
  final String errMessage;
  AssignmentDetailsFailure(this.errMessage);
}

// ==========================================================================
//? --- 2. Action States Base (CRUD Operations) ---
// ==========================================================================

sealed class AssignmentActionState extends AssignmentDetailsState {}

// --- Delete Single Item States ---
final class DeleteAssignmentItemLoading extends AssignmentActionState {}

final class DeleteAssignmentItemSuccess extends AssignmentActionState {
  final AssignmentModel assignment;
  final String message;
  DeleteAssignmentItemSuccess({required this.assignment, required this.message});
}

final class DeleteAssignmentItemFailure extends AssignmentActionState {
  final String errMessage;
  DeleteAssignmentItemFailure(this.errMessage);
}

// --- Delete Entire Assignment States ---
final class DeleteAssignmentLoading extends AssignmentActionState {}

final class DeleteAssignmentSuccess extends AssignmentActionState {
  final String message;
  DeleteAssignmentSuccess(this.message);
}

final class DeleteAssignmentFailure extends AssignmentActionState {
  final String errMessage;
  DeleteAssignmentFailure(this.errMessage);
}
