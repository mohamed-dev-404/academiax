import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/announcements/data/model/comment_details.dart';

class AnnouncementDetailsModel {
  final String id;
  final String title;
  final String content;
  final List<CommentDetails> comments;

  AnnouncementDetailsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.comments,
  });

  /// Factory constructor to create an AnnouncementDetailsModel from JSON
  factory AnnouncementDetailsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetailsModel(
      id: (json[ApiKeys.id] as String?) ?? '',
      title: (json[ApiKeys.title] as String?) ?? 'No Title',
      content: (json[ApiKeys.content] as String?) ?? 'No Content',
      comments:
          (json[ApiKeys.comments] as List<dynamic>?)
              ?.map((e) => CommentDetails.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Method to convert AnnouncementDetailsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.content: content,
      ApiKeys.comments: comments,
    };
  }

  /// CopyWith method to create a copy of the model with updated fields
  AnnouncementDetailsModel copyWith({
    String? id,
    String? title,
    String? content,
    List<CommentDetails>? comments,
  }) {
    return AnnouncementDetailsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      comments: comments ?? this.comments,
    );
  }
}
