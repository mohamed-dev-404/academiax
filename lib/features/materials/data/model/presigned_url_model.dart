import 'package:sams_app/core/utils/constants/api_keys.dart';

class PresignedUrlModel {
  final String originalFileName;
  final String key;
  final String uploadUrl;

  PresignedUrlModel({
    required this.originalFileName,
    required this.key,
    required this.uploadUrl,
  });

  factory PresignedUrlModel.fromJson(Map<String, dynamic> json) =>
      PresignedUrlModel(
        originalFileName: json[ApiKeys.originalFileName],
        key: json[ApiKeys.key],
        uploadUrl: json[ApiKeys.uploadUrl],
      );
}
