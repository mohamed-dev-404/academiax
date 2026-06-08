//! Funcion that handle Dio Exceptions and throw suitable ApiException on each case of Dio Exceptions
import 'package:dio/dio.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/errors/models/error_model.dart';

void handleDioExceptions(DioException e) {
  final String errorMessage;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      errorMessage =
          'Connection timeout. Please check your internet connection';
      break;

    case DioExceptionType.sendTimeout:
      errorMessage = 'Send timeout. Please try again';
      break;

    case DioExceptionType.receiveTimeout:
      errorMessage = 'Server is taking too long to respond';
      break;

    case DioExceptionType.badCertificate:
      errorMessage = 'Security certificate error';
      break;

    case DioExceptionType.cancel:
      errorMessage = 'Request was cancelled';
      break;

    case DioExceptionType.connectionError:
      errorMessage = _handleConnectionError(e);
      break;

    case DioExceptionType.unknown:
      errorMessage = _handleUnknownError(e);
      break;

    case DioExceptionType.badResponse:
      errorMessage = _handleBadResponse(e);
      break;
  }

  throw ApiException(
    errorModel: ErrorModel(
      errorMessage: errorMessage,
      statusCode: e.response?.statusCode,
    ),
  );
}

//? handle Connection Error type
String _handleConnectionError(DioException e) {
  if (e.error?.toString().contains('SocketException') ?? false) {
    return 'No internet connection. Please check your network';
  }
  return 'Connection error. Please try again';
}

//? handle Unknown Error type
String _handleUnknownError(DioException e) {
  if (e.error?.toString().contains('SocketException') ?? false) {
    return 'No internet connection. Please check your network';
  }
  return e.error?.toString() ??
      'An unexpected error occurred. Please try again';
}

//? handle Bad Response type
String _handleBadResponse(DioException e) {
  final statusCode = e.response?.statusCode;
  final responseData = e.response?.data;

  //* Try to extract error message from response
  if (responseData != null && responseData is Map<String, dynamic>) {
    try {
      return ErrorModel.fromJson(responseData).errorMessage;
    } catch (_) {
      // If parsing fails, skip and use status code based messages
    }
  }

  //* If parsing fails, Fallback to status code based messages
  switch (statusCode) {
    case 400:
      return 'Bad request. Please check your input';
    case 401:
      return 'Unauthorized. Please login again';
    case 403:
      return 'Access forbidden';
    case 404:
      return 'Resource not found';
    case 409:
      return 'Conflict. This resource already exists';
    case 422:
      return 'Validation error. Please check your input';
    case 500:
      return 'Internal server error. Please try later';
    case 502:
    case 503:
    case 504:
      return 'Server is unavailable. Please try later';
    default:
      return 'Server error (${statusCode ?? 'unknown'})';
  }
}
