import 'package:dartz/dartz.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/base_response.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/all_submissions_model.dart';
import 'package:sams_app/features/assignments/data/model/get_submission_details/submission_details_model.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/grade_submission_request.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';

class AssignmentSubmissionRepoImpl implements AssignmentSubmissionRepo {
  AssignmentSubmissionRepoImpl({required this.api});
  final ApiConsumer api;

  //? 1- Get all submissions
  @override
  Future<Either<String, List<AllSubmissionsModel>>> getAllSubmissions({
    required String assignmentId,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.getSubmissions(assignmentId)}?size=$size&page=$page',
      );

      List<AllSubmissionsModel> submissions =
          (response[ApiKeys.data] as List?)
              ?.map((e) => AllSubmissionsModel.fromJson(e))
              .toList() ??
          [];

      return right(submissions);
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
        EndPoints.getSubmissionDetails(submissionId),
      );

      final submission =
          SubmissionDetailsModel.fromJson(response[ApiKeys.data]);

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
      final response=await api.post(
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
      final response=await api.post(
        EndPoints.approveSubmissions(assignmentId),
      );

      return right(BaseResponse.fromJson(response));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }
}