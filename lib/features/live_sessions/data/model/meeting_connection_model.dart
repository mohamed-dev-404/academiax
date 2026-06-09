import 'package:sams_app/core/utils/constants/api_keys.dart';

class MeetingConnectionModel {
  final String id;
  final String academicId;
  final String channelName;
  final String token;
  final int validityPeriod;

  MeetingConnectionModel({
    required this.id,
    required this.academicId,
    required this.channelName,
    required this.token,
    required this.validityPeriod,
  });

  factory MeetingConnectionModel.fromJson(Map<String, dynamic> json) {
    return MeetingConnectionModel(
      id: json[ApiKeys.id],
      academicId: json[ApiKeys.academicId].toString(), 
      channelName: json[ApiKeys.channelName],
      token: json[ApiKeys.token],
      validityPeriod: json[ApiKeys.validityPeriod] ?? 0,
    );
  }
}