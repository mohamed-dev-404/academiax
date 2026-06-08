import 'package:sams_app/core/utils/constants/api_keys.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String content;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
  });

  /// Factory constructor to create an AnnouncementModel from JSON
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: (json[ApiKeys.id] as String?) ?? '',
      title: (json[ApiKeys.title] as String?) ?? 'No Title',
      content: (json[ApiKeys.content] as String?) ?? 'No Content',
    );
  }

  /// Method to convert AnnouncementModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.content: content,
    };
  }

  /// CopyWith method to create a copy of the model with updated fields
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
