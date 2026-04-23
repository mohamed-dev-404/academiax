import 'package:dartz/dartz.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';

class AssignmentRepoImpl implements AssignmentRepo {
  AssignmentRepoImpl({required this.api});
  ApiConsumer api;

  @override
  Future<Either<String, List<AssignmentModel>>> fetchAssignments({
    required String courseId,
  }) async {
    try {
      final response = await api.get(EndPoints.getCourseAssignments(courseId));

      List<AssignmentModel> assignments =
          (response[ApiKeys.data] as List?)
              ?.map((item) => AssignmentModel.fromJson(item))
              .toList() ??
          [];

      return right(assignments);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, AssignmentModel>> fetchAssignmentDetails({
    required String assignmentId,
  }) async {
    try {
      final response = await api.get(
        EndPoints.getAssignmentDetails(assignmentId),
      );
      return right(AssignmentModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteAssignment({
    required String assignmentId,
  }) async {
    try {
      await api.delete(EndPoints.deleteAssignment(assignmentId));
      return right(unit);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  
}
