import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import '../../../data/model/create_meeting_request.dart';
import '../../../data/model/meeting_model.dart';
import '../../../data/repos/meeting_repo.dart';
import './meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState>
    with CubitMessageMixin, SafeEmitMixin {
  final MeetingRepo meetingRepo;
  List<MeetingModel> _meetings = [];

  MeetingCubit(this.meetingRepo) : super(MeetingInitial());

  Future<void> fetchMeetings({required String courseId}) async {
    emit(FetchMeetingsLoading());

    final result = await meetingRepo.fetchCourseMeetings(courseId: courseId);

    result.fold(
      (failure) => emit(FetchMeetingsFailure(failure)),
      (meetings) {
        _meetings = meetings;
        emit(FetchMeetingsSuccess(_meetings));
      },
    );
  }

  Future<void> createMeeting({
    required String courseId,
    required DateTime startTime,
  }) async {
    emit(CreateMeetingLoading());

    final result = await meetingRepo.createMeeting(
      courseId: courseId,
      request: CreateMeetingRequest(startTime: startTime),
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(CreateMeetingFailure(failure));
      },
      (_) {
        fetchMeetings(courseId: courseId);
        emit(
          CreateMeetingSuccess(
            message: 'Meeting created successfully!',
          ),
        );
      },
    );
  }

  Future<void> joinMeeting({required String meetingId}) async {
    emit(JoinMeetingLoading());

    final result = await meetingRepo.joinMeeting(meetingId: meetingId);

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(JoinMeetingFailure(failure));
      },
      (url) => emit(
        JoinMeetingSuccess(url: url),
      ),
    );
  }

  Future<void> endMeeting({
    required String meetingId,
    required String courseId,
  }) async {
    emit(EndMeetingLoading());

    final result = await meetingRepo.endMeeting(meetingId: meetingId);

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(EndMeetingFailure(failure));
      },
      (_) {
        fetchMeetings(courseId: courseId);
        emit(EndMeetingSuccess('Session ended successfully!'));
      },
    );
  }

  Future<void> deleteMeeting({
    required String meetingId,
    required String courseId,
  }) async {
    emit(DeleteMeetingLoading());

    final result = await meetingRepo.deleteMeeting(meetingId: meetingId);

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(DeleteMeetingFailure(failure));
      },
      (_) {
        _meetings.removeWhere((m) => m.id == meetingId);
        emit(FetchMeetingsSuccess(List.from(_meetings)));
        emit(DeleteMeetingSuccess('Session deleted!'));
      },
    );
  }
}
