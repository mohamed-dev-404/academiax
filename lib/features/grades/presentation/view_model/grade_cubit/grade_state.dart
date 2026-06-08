part of 'grade_cubit.dart';

sealed class GradeState extends Equatable {
  const GradeState();

  @override
  List<Object> get props => [];
}

final class GradeInitial extends GradeState {}

//  This state is used when fetching grades for instructors or students.
final class GradeLoading extends GradeState {}

/// Emitted when only the table data is being refreshed (search/pagination change).
/// The header and pagination footer should NOT rebuild — only the table body.
final class GradeTableLoading extends GradeState {}

final class GradeLoadedSuccessfully extends GradeState {}

final class GradeLoadingFailed extends GradeState {
  final String errorMessage;

  const GradeLoadingFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class ToggleClassworkVisibilitySuccess extends GradeState {
  final String classworkId;
  final DateTime timestamp;

  ToggleClassworkVisibilitySuccess(this.classworkId)
    : timestamp = DateTime.now();

  @override
  List<Object> get props => [classworkId, timestamp];
}

final class ToggleClassworkVisibilityFailed extends GradeState {
  final String errorMessage;
  final DateTime timestamp;

  ToggleClassworkVisibilityFailed(this.errorMessage)
    : timestamp = DateTime.now();

  @override
  List<Object> get props => [errorMessage, timestamp];
}
