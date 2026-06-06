import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/services/file_saver_service/file_saver.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_response_model.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/data/repos/grade_repo.dart';

class GradeRepoImpl implements GradeRepo {
  final ApiConsumer api;
  GradeRepoImpl({required this.api});

  @override
  Future<Either<String, List<StudentGradeModel>>> getStudentGrades({
    required String courseId,
  }) async {
    try {
      final response = await api.get(
        EndPoints.getMyGrades(courseId: courseId),
      );

      final List<StudentGradeModel> grades =
          (response[ApiKeys.data] as List)
              .map((item) => StudentGradeModel.fromJson(item as Map<String, dynamic>))
              .toList();

      return Right(grades);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// get all grades for a specific course. required [courseId] & optional [search], [page], [perPage]
  /// [courseId] -> The identifier of the course.
  /// [page] -> The current page number.
  /// [perPage] -> The number of items per page.
  /// [search] -> The search query.
  /// Returns [Right(GradeResponseModel)] on success, [Left(errorMessage)] on failure.
  @override
  Future<Either<String, GradeResponseModel>> getAllGrades({
    required String courseId,
    int page = 1,
    int perPage = 10,
    String search = '',
  }) async {
    try {
      // hit get all grades endpoint
      var response = await api.get(
        EndPoints.getInstructorGrades(courseId: courseId),
        queryParameters: {
          ApiKeys.search: search,
          ApiKeys.page: page,
          ApiKeys.size: perPage,
        },
      );

      return Right(GradeResponseModel.fromJson(response)); // success case
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  /// Exports grades for [courseId] as a CSV file.
  /// Downloads raw bytes from the API, then saves them to disk via [saveFile].
  ///   - Web   → triggers the browser’s native Save dialog
  ///   - Mobile → writes to the device’s Downloads folder
  @override
  Future<Either<String, void>> exportGrades({required String courseId}) async {
    try {
      final Uint8List bytes = await api.download(
        EndPoints.exportGrades(courseId: courseId),
      );

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      await saveFile(bytes, 'grades_$timestamp.csv');

      return const Right(null); // success — file saved
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  /// Toggles the visibility of a specific classwork for all students in a course.
  /// [courseId] -> The identifier of the course.
  /// [classworkId] -> The identifier of the classwork to toggle visibility for.
  /// Returns [Right(null)] on success, [Left(errorMessage)] on failure.
  @override
  Future<Either<String, void>> toggleClassworkVisibility({
    required String courseId,
    required String classworkId,
  }) async {
    try {
      await api.patch(
        EndPoints.toggleClassworkVisibility(
          courseId: courseId,
          classworkId: classworkId,
        ),
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
