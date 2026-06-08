import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/grades/data/repos/grade_repo.dart';

part 'export_grade_state.dart';

class ExportGradeCubit extends Cubit<ExportGradeState> {
  final GradeRepo _repo;

  ExportGradeCubit(this._repo) : super(ExportGradeInitial());

  /// Triggers the export-grades request for [courseId].
  /// Emits [ExportGradeLoading] → [ExportGradeSuccess] or [ExportGradeFailure].
  Future<void> exportGrades({required String courseId}) async {
    emit(ExportGradeLoading());

    final result = await _repo.exportGrades(courseId: courseId);

    result.fold(
      (errorMessage) => emit(ExportGradeFailure(errorMessage)),
      (_) => emit(ExportGradeSuccess()),
    );
  }
}
