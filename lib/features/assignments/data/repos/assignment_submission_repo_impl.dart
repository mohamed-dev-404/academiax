import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/extentions/filter_files_helper.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/services/s3_upload_service.dart';
import 'package:sams_app/features/assignments/data/model/base_response.dart';
import 'package:sams_app/features/assignments/data/model/file_upload_reference.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/all_submissions_model.dart';
import 'package:sams_app/features/assignments/data/model/get_submission_details/submission_details_model.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/grade_submission_request.dart';
import 'package:sams_app/features/assignments/data/model/submit_items_request.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';
import 'package:sams_app/features/materials/data/model/presigned_url_model.dart';

class AssignmentSubmissionRepoImpl implements AssignmentSubmissionRepo {
  AssignmentSubmissionRepoImpl({required this.api, required this.s3Service});
  final ApiConsumer api;
  final S3UploadService s3Service;

  //? 1- Get all submissions
  @override
  Future<Either<String, AllSubmissionsModel>> getAllSubmissions({
    required String assignmentId,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.getSubmissions(assignmentId)}?size=$size&page=$page',
      );

    final result = AllSubmissionsModel.fromJson(response);

      return right(result);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //? 2- Get submission details
  @override
  Future<Either<String, SubmissionDetailsModel>> getSubmissionDetails({
    required String submissionId,
  }) async {
    try {
      final response = await api.get(
        EndPoints.getAssignmentSubmissionDetails(submissionId),
      );

      final submission = SubmissionDetailsModel.fromJson(
        response[ApiKeys.data],
      );

      return right(submission);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //? 3- Grade submission
  @override
  Future<Either<String, BaseResponse>> gradeSubmission({
    required String submissionId,
    required GradeSubmissionRequest request,
  }) async {
    try {
      final response = await api.post(
        EndPoints.gradeSubmission(submissionId),
        data: request.toJson(),
      );

      return right(BaseResponse.fromJson(response));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //? 4- Approve all submissions
  @override
  Future<Either<String, BaseResponse>> approveAllSubmissions({
    required String assignmentId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.approveSubmissions(assignmentId),
      );

      return right(BaseResponse.fromJson(response));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> submitAssignment({
    required String assignmentId,
    required String courseId,
    required List<XFile> files,
    required String classworkId,
  }) async {
    try {
      final metadataList = await _getBatchPresignedUrls(
        files,
        courseId,
        classworkId,
      );

      await Future.wait(
        metadataList.asMap().entries.map((entry) {
          return s3Service.uploadFile(
            url: entry.value.uploadUrl,
            xFile: files[entry.key],
            fileName: entry.value.originalFileName,
            contentType: files[entry.key].name.fileContentType,
          );
        }),
      );

      final itemsRefs = metadataList
          .map(
            (m) => FileUploadReference(
              originalFileName: m.originalFileName,
              contentType: m.originalFileName.fileContentType,
              contentReference: m.key,
            ),
          )
          .toList();

      final response = await api.post(
        EndPoints.submitAssignment(assignmentId),
        data: SubmitAssignmentRequest(submittedItems: itemsRefs).toJson(),
      );

      return right(response[ApiKeys.message] ?? 'Success');
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left('Submit failed: ${e.toString()}');
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
        ApiKeys.context: 'assignment_submissions',
        ApiKeys.classworkId: classworkId,
        ApiKeys.filesMetadata: filesMetadata,
      },
    );

    final List data = response[ApiKeys.data];
    return data.map((e) => PresignedUrlModel.fromJson(e)).toList();
  }

  @override
  Future<Either<String, String>> unsubmitAssignment({
    required String submissionId,
  }) async {
    try {
      final response = await api.delete(
        EndPoints.unsubmitAssignment(submissionId),
      );

      debugPrint(response.toString());

      return right(response[ApiKeys.message] ?? 'Success');
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }
}
