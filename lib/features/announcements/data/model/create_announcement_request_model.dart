import 'package:sams_app/core/utils/constants/api_keys.dart';

class CreateAnnouncementRequestModel {
  final String title;
  final String content;

  CreateAnnouncementRequestModel({
    required this.title,
    required this.content,
  });

  /// Converts the model to a JSON map for the API request body.
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.title: title,
      ApiKeys.content: content,
    };
  }
}
