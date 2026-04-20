import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';

//* Base state for Assignments feature.
//* All Assignment states extend this class.
@immutable
sealed class AssignmentFetchState {}

/// Initial state before any action.
final class AssignmentFetchInitial extends AssignmentFetchState {}

// --- Fetch List Section ---

//? Emitted while loading assignments list.
final class AssignmentFetchLoading extends AssignmentFetchState {}

//* Emitted when assignments list loaded successfully.
final class AssignmentFetchSuccess extends AssignmentFetchState {
  final List<AssignmentModel> assignments;
  AssignmentFetchSuccess(this.assignments);
}

//! Emitted when loading assignments list fails.
final class AssignmentFetchFailure extends AssignmentFetchState {
  final String errMessage;
  AssignmentFetchFailure(this.errMessage);
}
