import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/grade_submission_request.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';
import 'assignment_submission_state.dart';

class AssignmentSubmissionCubit extends Cubit<AssignmentSubmissionState>
    with CubitMessageMixin, SafeEmitMixin {
  final AssignmentSubmissionRepo repo;

  AssignmentSubmissionCubit(this.repo)
      : super(AssignmentSubmissionInitial());

  // =================  GET ALL =================

  Future<void> getAllSubmissions({
    required String assignmentId,
    int page = 1,
    int size = 20,
  }) async {
    emit(SubmissionsLoading());

    final result = await repo.getAllSubmissions(
      assignmentId: assignmentId,
      page: page,
      size: size,
    );

    result.fold(
      (failure) => emit(SubmissionsFailure(failure)),
      (data) => emit(SubmissionsSuccess(data)),
    );
  }

  // =================  DETAILS =================

  Future<void> getSubmissionDetails({
    required String submissionId,
  }) async {
    emit(SubmissionDetailsLoading());

    final result = await repo.getSubmissionDetails(
      submissionId: submissionId,
    );

    result.fold(
      (failure) => emit(SubmissionDetailsFailure(failure)),
      (data) => emit(SubmissionDetailsSuccess(data)),
    );
  }

  // =================  GRADE =================

  Future<void> gradeSubmission({
    required String submissionId,
    required GradeSubmissionRequest request,
  }) async {
    emit(GradeSubmissionLoading());

    final result = await repo.gradeSubmission(
      submissionId: submissionId,
      request: request,
    );

    result.fold(
      (failure) => emit(GradeSubmissionFailure(failure)),
      (response) {
        emit(GradeSubmissionSuccess(response));
        emitMessage(response.message); 
      },
    );
  }

  // =================  APPROVE ALL =================

  Future<void> approveAllSubmissions({
    required String assignmentId,
  }) async {
    emit(ApproveAllLoading());

    final result = await repo.approveAllSubmissions(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) => emit(ApproveAllFailure(failure)),
      (response) {
        emit(ApproveAllSuccess(response));
        emitMessage(response.message);
      },
    );
  }
}