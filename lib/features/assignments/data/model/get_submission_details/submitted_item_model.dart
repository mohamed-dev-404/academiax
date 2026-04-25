import 'package:sams_app/core/utils/constants/api_keys.dart';

class SubmittedItemModel {
  final String originalFileName;
  final String key;
  final String displayUrl;

  SubmittedItemModel({
    required this.originalFileName,
    required this.key,
    required this.displayUrl,
  });

  factory SubmittedItemModel.fromJson(Map<String, dynamic> json) {
    return SubmittedItemModel(
      originalFileName: json[ApiKeys.originalFileName],
      key: json[ApiKeys.key],
      displayUrl: json[ApiKeys.displayUrl],
    );
  }
}