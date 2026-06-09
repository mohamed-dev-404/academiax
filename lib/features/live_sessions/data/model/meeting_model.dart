import 'package:intl/intl.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/live_sessions/data/model/helper/meeting_state_enum.dart';
import 'package:sams_app/features/live_sessions/data/model/helper/parse_date_helper.dart';

class MeetingModel {
  final String id;
  final String channelName;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration;
  final String status;

  MeetingModel({
    required this.id,
    required this.channelName,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.status,
  });

  //! --- Display Getters (Using your intl style) ---
  String get formattedStartTime =>
      DateFormat('dd MMM, hh:mm a').format(startTime);
  String get formattedEndTime => endTime != null
      ? DateFormat('dd MMM, hh:mm a').format(endTime!)
      : 'Ongoing';

  //! --- Logic Getters ---
  MeetingStateEnum get meetingState => MeetingStateEnum.fromString(status);

  bool get isOngoing => meetingState == MeetingStateEnum.ongoing;
  bool get isEnded => meetingState == MeetingStateEnum.ended;
  bool get isScheduled => meetingState == MeetingStateEnum.scheduled;

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json[ApiKeys.id] ?? '',
      channelName: json[ApiKeys.channelName] ?? '',
      startTime: parseDate(json[ApiKeys.startTime]),
      endTime: json[ApiKeys.endTime] != null ? parseDate(json[ApiKeys.endTime]) : null,
      duration: json[ApiKeys.duration] ?? 0,
      status: json[ApiKeys.status] ?? 'ENDED',
    );
  }
}
