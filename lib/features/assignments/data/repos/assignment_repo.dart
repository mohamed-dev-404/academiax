import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<Either<String, AssignmentModel>> deleteAssignmentItem({
    required String assignmentId,
    required String itemKey,
  });

  Future<Either<String, AssignmentModel>> addItemsToAssignment({
    required String assignmentId,
    required String courseId,
    required List<XFile> newFiles,
    required String classworkId,
  });

  Future<Either<String, AssignmentModel>> uploadAssignmentFullWorkflow({
    required String courseId,
    required String title,
    required String description,
    required String classworkId,
    required bool enablePlagiarismCheck,
     int? plagiarismThreshold,
    required String dueDate,
    required List<XFile> selectedFiles,
  });
}
