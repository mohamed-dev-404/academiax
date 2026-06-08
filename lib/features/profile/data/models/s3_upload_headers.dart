import 'package:sams_app/core/utils/constants/api_keys.dart';

//* Formats necessary headers for direct binary upload to S3
class S3UploadHeaders {
  final String contentType;
  final int contentLength;

  S3UploadHeaders({required this.contentType, required this.contentLength});

  // Maps headers for S3 direct binary upload
  Map<String, dynamic> toMap() => {
    ApiKeys.contentTypeHeader: contentType,
    ApiKeys.contentLengthHeader: contentLength,
  };
}
