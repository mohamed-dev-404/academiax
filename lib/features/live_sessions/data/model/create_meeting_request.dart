import 'package:sams_app/core/utils/constants/api_keys.dart';

class CreateMeetingRequest {
  final DateTime startTime;

  CreateMeetingRequest({
    required this.startTime,
  });

  /// Converts the model to a JSON map for the API request
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.startTime: startTime.toUtc().toIso8601String(),
    };
  }
}
