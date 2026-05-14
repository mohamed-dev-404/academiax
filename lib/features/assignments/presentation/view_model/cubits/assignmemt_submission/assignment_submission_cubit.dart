import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/all_submissions_model.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/assignment_submission_model.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/pagination_model.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/state_model.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/student_info_model.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/grade_submission_request.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';

import 'assignment_submission_state.dart';

class AssignmentSubmissionCubit extends Cubit<AssignmentSubmissionState>
    with CubitMessageMixin, SafeEmitMixin {
  final AssignmentSubmissionRepo repo;

  AssignmentSubmissionCubit(this.repo) : super(AssignmentSubmissionInitial());

  // ================= GET ALL SUBMISSIONS =================

/// Stores the latest successful response
/// Used to keep old data visible while loading new actions
AllSubmissionsModel? currentSubmissions;

/// Current loaded page number
int currentPage = 1;

/// Indicates if pagination request is running
bool isLoadingMore = false;

/// Determines if more pages exist
bool hasNextPage = true;

/// Stores all loaded submissions from all pages
List<AssSubmissionModel> allSubmissions = [];

Future<void> getAllSubmissions({
  required String assignmentId,
  int page = 1,
  int size = 20,
  bool showLoading = true,
}) async {

  /// Show full-screen loading ONLY on first page
  /// Example:
  /// Opening screen لأول مرة
  if (showLoading && page == 1) {
    emit(SubmissionsLoading());
  }

  /// Pagination loading
  /// User reached bottom of page
  if (page > 1) {
    isLoadingMore = true;
  }

  /// API request
  final result = await repo.getAllSubmissions(
    assignmentId: assignmentId,
    page: page,
    size: size,
  );

  result.fold(

    /// FAILURE
    (failure) {

      /// Stop pagination loader
      isLoadingMore = false;

      emit(SubmissionsFailure(failure));
    },

    /// SUCCESS
    (data) {

      /// Update current page number
      currentPage = data.pagination.currentPage;

      /// Check if API still has more pages
      hasNextPage = data.pagination.hasNextPage;

      /// FIRST PAGE
      /// Replace old list with fresh data
      if (page == 1) {
        allSubmissions = data.submissions;
      }

      /// NEXT PAGES
      /// Append new page items to old list
      else {
        allSubmissions.addAll(data.submissions);
      }

      /// Create updated response with merged submissions
      final updatedData = AllSubmissionsModel(

        stats: data.stats,

        /// Combined list from all pages
        submissions: allSubmissions,

        pagination: data.pagination,
      );

      /// Save latest successful response
      currentSubmissions = updatedData;

      /// Stop bottom loading indicator
      isLoadingMore = false;

      /// Emit updated UI
      emit(SubmissionsSuccess(updatedData));
    },
  );
}
///// Fake Data To Test Pagination and Loading More
// Future<void> getAllSubmissions({
//     required String assignmentId,
//     int page = 1,
//     int size = 20,
//     bool showLoading = true,
//   }) async {

//     /// First loading
//     if (showLoading && page == 1) {
//       emit(SubmissionsLoading());
//     }

//     /// Load more
//     if (page > 1) {

//       isLoadingMore = true;

//       /// IMPORTANT
//       /// Rebuild UI to show bottom loader
//       if (currentSubmissions != null) {
//         emit(
//           SubmissionsSuccess(
//             currentSubmissions!,
//           ),
//         );
//       }
//     }

//     /// Fake API delay
//     await Future.delayed(
//       const Duration(seconds: 1),
//     );

//     /// Fake Data
//     final fakeList = List.generate(
//       size,
//       (index) {

//         final itemNumber =
//             ((page - 1) * size) + index + 1;

//         return AssSubmissionModel(

//           id: '$itemNumber',

//           studentInfo: StudentInfoModel(
//             name: 'Student $itemNumber',
//             academicId: '20220$itemNumber',
//           ),

//           submittedAt:
//               DateTime.now().toIso8601String(),

//           submittedItems: [],

//           neededReview:
//               itemNumber % 2 == 0,

//           points: 10,

//           earnedPoints: 8,
//         );
//       },
//     );

//     /// First page
//     if (page == 1) {
//       allSubmissions = fakeList;
//     }

//     /// Next pages
//     else {
//       allSubmissions.addAll(fakeList);
//     }

//     /// Pagination info
//     currentPage = page;

//     hasNextPage = page < 5;

//     /// Build fake response
//     final fakeData = AllSubmissionsModel(

//       stats: StateModel(

//         submitted:
//             allSubmissions.length,

//         marked: allSubmissions
//             .where((e) => !e.neededReview)
//             .length,

//         unmarked: allSubmissions
//             .where((e) => e.neededReview)
//             .length,
//       ),

//       submissions: allSubmissions,

//       pagination: PaginationModel(
//         totalElements: 100,
//         currentPage: page,
//         size: size,
//         totalPages: 5,
//         hasNextPage: hasNextPage,
//         hasPrevPage: page > 1,
//       ),
//     );

//     currentSubmissions = fakeData;

//     isLoadingMore = false;

//     emit(
//       SubmissionsSuccess(fakeData),
//     );
//   }

  // =================  DETAILS =================

  Future<void> getSubmissionDetails({
    required String submissionId,
    bool showLoading = true,
  }) async {
    // Added showLoading parameter to allow silent refresh after grading
    if (showLoading) {
      emit(SubmissionDetailsLoading());
    }

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
    // Emit loading while keeping the current data visible
    emit(ApproveAllLoading(submissions: currentSubmissions!));

    final result = await repo.approveAllSubmissions(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) => emit(ApproveAllFailure(failure)),
      (response) {
        // Emit success while keeping the current data visible
        emit(ApproveAllSuccess(response: response, submissions: currentSubmissions!));
        emitMessage(response.message);
      },
    );
  }

  // ================= SIMILARITY REPORT =================

  Future<void> getSimilarityReport({
    required String submissionId,
  }) async {
    emit(SimilarityReportLoading());

    final result = await repo.getSimilarityReport(
      submissionId: submissionId,
    );

    result.fold(
      (failure) => emit(SimilarityReportFailure(failure)),
      (report) => emit(SimilarityReportSuccess(report)),
    );
  }
}
