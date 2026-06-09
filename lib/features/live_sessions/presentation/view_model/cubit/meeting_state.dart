import 'package:flutter/foundation.dart';

import '../../../data/model/meeting_model.dart';

@immutable
sealed class MeetingState {}

final class MeetingInitial extends MeetingState {}

// --- Fetch Meetings States ---
final class FetchMeetingsLoading extends MeetingState {}

final class FetchMeetingsSuccess extends MeetingState {
  final List<MeetingModel> meetings;
  FetchMeetingsSuccess(this.meetings);
}

final class FetchMeetingsFailure extends MeetingState {
  final String errMessage;
  FetchMeetingsFailure(this.errMessage);
}

// --- Create Meeting States ---
final class CreateMeetingLoading extends MeetingState {}

final class CreateMeetingSuccess extends MeetingState {
  final String message;
  CreateMeetingSuccess({required this.message});
}

final class CreateMeetingFailure extends MeetingState {
  final String errMessage;
  CreateMeetingFailure(this.errMessage);
}

// --- Join Meeting States ---
final class JoinMeetingLoading extends MeetingState {}

final class JoinMeetingSuccess extends MeetingState {
  final String url;
  JoinMeetingSuccess({ required this.url});
}

final class JoinMeetingFailure extends MeetingState {
  final String errMessage;
  JoinMeetingFailure(this.errMessage);
}

// --- End Meeting States ---
final class EndMeetingLoading extends MeetingState {}

final class EndMeetingSuccess extends MeetingState {
  final String message;
  EndMeetingSuccess(this.message);
}

final class EndMeetingFailure extends MeetingState {
  final String errMessage;
  EndMeetingFailure(this.errMessage);
}

// --- Delete Meeting States ---
final class DeleteMeetingLoading extends MeetingState {}

final class DeleteMeetingSuccess extends MeetingState {
  final String message;
  DeleteMeetingSuccess(this.message);
}

final class DeleteMeetingFailure extends MeetingState {
  final String errMessage;
  DeleteMeetingFailure(this.errMessage);
}
