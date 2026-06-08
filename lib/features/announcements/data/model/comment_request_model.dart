import 'package:sams_app/core/utils/constants/api_keys.dart';

class CommentRequestModel {
  final String content;

  CommentRequestModel({required this.content});

  Map<String, dynamic> toJson() => {
    ApiKeys.content: content,
  };
}
