import 'package:sams_app/core/utils/constants/api_keys.dart';

class UpdateAnnouncementRequestModel {
  final String? title;
  final String? content;

  UpdateAnnouncementRequestModel({
    this.title,
    this.content,
  });

  /// Converts the model instance into a JSON Map.
  ///
  /// It dynamically constructs the map to include only the non-null fields.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (title != null) {
      data[ApiKeys.title] = title;
    }

    if (content != null) {
      data[ApiKeys.content] = content;
    }

    return data;
  }
}
