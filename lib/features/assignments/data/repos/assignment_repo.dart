import 'package:dartz/dartz.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';

abstract class AssignmentRepo {
  Future<Either<String, List<AssignmentModel>>> fetchAssignments({
    required String courseId,
  });

  Future<Either<String, AssignmentModel>> fetchAssignmentDetails({
    required String assignmentId,
  });

  Future<Either<String, Unit>> deleteAssignment({
    required String assignmentId,
  });


}
