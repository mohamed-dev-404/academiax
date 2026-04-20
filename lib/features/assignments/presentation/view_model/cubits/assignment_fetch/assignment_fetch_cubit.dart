import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
import 'assignment_fetch_state.dart';

//* Manages assignment-related states: Fetching assignments from API
class AssignmentFetchCubit extends Cubit<AssignmentFetchState>
    with CubitMessageMixin, SafeEmitMixin {
  final AssignmentRepo assignmentRepo;

  AssignmentFetchCubit(this.assignmentRepo) : super(AssignmentFetchInitial());

  //* Fetches assignments directly from the network
  Future<void> fetchAssignments({required String courseId}) async {
    // 1. PHASE: Show loading indicator
    emit(AssignmentFetchLoading());

    // 2. PHASE: Remote data synchronization
    final result = await assignmentRepo.fetchAssignments(courseId: courseId);

    result.fold(
      (failure) {
        //* Error Handling: Emit failure state with error message
        emit(AssignmentFetchFailure(failure));
      },
      //* Update UI with the fetched assignments
      (assignments) => emit(AssignmentFetchSuccess(assignments)),
    );
  }
}
