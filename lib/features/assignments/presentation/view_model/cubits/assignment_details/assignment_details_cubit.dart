import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_state.dart';

class AssignmentDetailsCubit extends Cubit<AssignmentDetailsState>
    with CubitMessageMixin, SafeEmitMixin {
  final AssignmentRepo assignmentRepo;

  AssignmentDetailsCubit(this.assignmentRepo)
    : super(AssignmentDetailsInitial());

  
  Future<void> fetchAssignmentDetails({required String assignmentId}) async {
    emit(AssignmentDetailsLoading());

    final result = await assignmentRepo.fetchAssignmentDetails(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) => emit(AssignmentDetailsFailure(failure)),
      (assignment) => emit(AssignmentDetailsSuccess(assignment)),
    );
  }
}
