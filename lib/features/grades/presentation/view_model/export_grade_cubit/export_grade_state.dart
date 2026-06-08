part of 'export_grade_cubit.dart';

sealed class ExportGradeState {}

/// Initial / idle state — no export in progress.
final class ExportGradeInitial extends ExportGradeState {}

/// Export request is in progress — show loading indicator on button.
final class ExportGradeLoading extends ExportGradeState {}

/// File downloaded and saved successfully.
final class ExportGradeSuccess extends ExportGradeState {}

/// Export failed — carries an error message to display as a toast.
final class ExportGradeFailure extends ExportGradeState {
  final String message;
  ExportGradeFailure(this.message);
}
