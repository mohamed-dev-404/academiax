import 'package:sams_app/core/utils/constants/api_keys.dart';

class BaseResponse {
  final String status;
  final String message;
  final dynamic data;

  BaseResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json[ApiKeys.status],
      message: json[ApiKeys.message],
      data: json[ApiKeys.data],
    );
  }
}