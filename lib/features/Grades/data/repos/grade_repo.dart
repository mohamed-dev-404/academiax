import 'package:dartz/dartz.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_response_model.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';

abstract class GradeRepo {
  Future<Either<String, StudentGradeModel>> getStudentGrades();


// Fetches all grades for a given [courseId] with pagination and optional search.
  Future<Either<String, GradeResponseModel>> getAllGrades({
    required String courseId,
    int page = 1,
    int perPage = 10,
    String search = '',
  });

  /// Exports grades for [courseId] and saves the resulting CSV file to disk.
  /// Returns [Right(null)] on success, [Left(errorMessage)] on failure.
  Future<Either<String, void>> exportGrades({required String courseId});
}
