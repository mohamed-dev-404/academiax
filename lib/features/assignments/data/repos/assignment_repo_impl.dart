import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/extentions/filter_files_helper.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/services/s3_upload_service.dart';
import 'package:sams_app/features/assignments/data/model/add_assignment_items_request.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/create_assignment_request.dart';
import 'package:sams_app/features/assignments/data/model/file_upload_reference.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
import 'package:sams_app/features/materials/data/model/presigned_url_model.dart';

class AssignmentRepoImpl implements AssignmentRepo {
  AssignmentRepoImpl({required this.api, required this.s3Service});
  ApiConsumer api;
  S3UploadService s3Service;

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

  @override
  Future<Either<String, AssignmentModel>> deleteAssignmentItem({
    required String assignmentId,
    required String itemKey,
  }) async {
    try {
      final response = await api.delete(
        EndPoints.deleteAssignmentItem(assignmentId),
        queryParameters: {ApiKeys.itemKey: itemKey},
      );

      return right(AssignmentModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, AssignmentModel>> addItemsToAssignment({
    required String assignmentId,
    required String courseId,
    required List<XFile> newFiles,
    required String classworkId,
  }) async {
    try {
      //! Step 1: Request Presigned URLs for new files
      final List<PresignedUrlModel> metadataList = await _getBatchPresignedUrls(
        newFiles,
        courseId,
        classworkId,
      );

      //! Step 2: Parallel S3 Upload
      await Future.wait(
        metadataList.asMap().entries.map((entry) {
          final index = entry.key;
          final metadata = entry.value;

          return s3Service.uploadFile(
            url: metadata.uploadUrl,
            xFile: newFiles[index],
            fileName: metadata.originalFileName,
            contentType: newFiles[index].name.fileContentType,
          );
        }),
      );

      //! Step 3: Confirm new items upload to backend
      final List<FileUploadReference> itemsRefs = metadataList
          .map(
            (m) => FileUploadReference(
              originalFileName: m.originalFileName,
              contentType: m.originalFileName.fileContentType,
              contentReference: m.key,
            ),
          )
          .toList();

      final response = await api.post(
        EndPoints.addAssignmentItems(assignmentId),
        data: AddAssignmentItemsRequest(assignmentItems: itemsRefs).toJson(),
      );

      return right(AssignmentModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left('Failed to add items: ${e.toString()}');
    }
  }

  Future<List<PresignedUrlModel>> _getBatchPresignedUrls(
    List<XFile> files,
    String courseId,
    String classworkId,
  ) async {
    final filesMetadata = await Future.wait(
      files.map((f) async {
        final name = f.name.isNotEmpty ? f.name : f.path.split('/').last;
        final bytes = await f.readAsBytes();
        return {
          ApiKeys.originalFileName: name,
          ApiKeys.contentType: name.fileContentType,
          ApiKeys.fileSize: bytes.length,
        };
      }),
    );
    //* Request upload URLs from the server
    final response = await api.post(
      EndPoints.createAssignmentUploadUrls(courseId),
      data: {
        ApiKeys.context: 'assignments',
        ApiKeys.classworkId: classworkId,
        ApiKeys.filesMetadata: filesMetadata,
      },
    );

    final List data = response[ApiKeys.data];
    return data.map((e) => PresignedUrlModel.fromJson(e)).toList();
  }

  //* UPLOAD assignment with full workflow (S3 + Backend)
  @override
  Future<Either<String, AssignmentModel>> uploadAssignmentFullWorkflow({
    required String courseId,
    required String classworkId,
    required String title,
    required String description,
    required String dueDate,
    required bool enablePlagiarismCheck,
    required int plagiarismThreshold,
    required List<XFile> selectedFiles,
  }) async {
    try {
      //! Step 1: Request Presigned URLs for attachments
      final List<PresignedUrlModel> metadataList = await _getBatchPresignedUrls(
        selectedFiles,
        courseId,
        classworkId,
      );

      //! Step 2: Parallel S3 Upload (Faster execution)
      await Future.wait(
        metadataList.asMap().entries.map((entry) {
          final index = entry.key;
          final metadata = entry.value;

          return s3Service.uploadFile(
            url: metadata.uploadUrl,
            xFile: selectedFiles[index],
            fileName: metadata.originalFileName,
            contentType: selectedFiles[index].name.fileContentType,
          );
        }),
      );

      //! Step 3: Confirm upload and create the Assignment entry
      final createdAssignment = await _confirmAssignmentUpload(
        courseId: courseId,
        title: title,
        description: description,
        dueDate: dueDate,
        plagiarismThreshold: plagiarismThreshold,
        classworkId: classworkId,
        metadata: metadataList,
        enablePlagiarism: enablePlagiarismCheck,
      );

      return Right(createdAssignment);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left('Assignment upload failed: ${e.toString()}');
    }
  }

  /// Private helper to finalize the creation on the backend
  /// Final Confirmation using the new Request Model
  Future<AssignmentModel> _confirmAssignmentUpload({
    required String courseId,
    required String title,
    required String description,
    required String dueDate,
    required int plagiarismThreshold,
    required String classworkId,
    required List<PresignedUrlModel> metadata,
    bool enablePlagiarism = false,
  }) async {
    //* 1. Prepare the file references from S3 metadata
    final List<FileUploadReference> items = metadata
        .map(
          (m) => FileUploadReference(
            originalFileName: m.originalFileName,
            contentType: m.originalFileName.fileContentType,
            contentReference: m.key, // S3 key
          ),
        )
        .toList();

    //* 2. Create the Request Object
    final requestBody = CreateAssignmentRequest(
      title: title,
      description: description,
      classworkId: classworkId,
      dueDate: dueDate,
      enablePlagiarismCheck: enablePlagiarism,
      plagiarismThreshold: plagiarismThreshold,
      assignmentItems: items,
    );

    //* 3. Send the request to Backend
    final response = await api.post(
      EndPoints.addAssignment(courseId),
      data: requestBody.toJson(),
    );

    return AssignmentModel.fromJson(response[ApiKeys.data]);
  }
}
