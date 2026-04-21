import 'package:sams_app/core/utils/constants/api_keys.dart';

class FileMetadata {
  final String originalFileName;
  final String contentType;
  final int fileSize;

  FileMetadata({
    required this.originalFileName,
    required this.contentType,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() => {
    ApiKeys.originalFileName: originalFileName,
    ApiKeys.contentType: contentType,
    ApiKeys.fileSize: fileSize,
  };
}
