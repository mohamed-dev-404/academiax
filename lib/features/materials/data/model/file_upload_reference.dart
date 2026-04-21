import 'package:sams_app/core/utils/constants/api_keys.dart';

class FileUploadReference {
  final String originalFileName;
  final String contentType;
  final String contentReference;

  FileUploadReference({
    required this.originalFileName,
    required this.contentType,
    required this.contentReference,
  });

  Map<String, dynamic> toJson() => {
    ApiKeys.originalFileName: originalFileName,
    ApiKeys.contentType: contentType,
    ApiKeys.contentReference: contentReference,
  };
}
