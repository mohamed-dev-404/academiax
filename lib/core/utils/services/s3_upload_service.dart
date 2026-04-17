import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/errors/models/error_model.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/constants/app_constants.dart';

//* Uploads a file directly to S3 using a presigned URL
class S3UploadService {
  final Dio _dio = Dio();

  Future<void> uploadFile({
    required String url,
    Uint8List? fileBytes,
    XFile? xFile,
    required String? fileName,
    required String contentType,
    Duration timeout = AppConstants.s3SendTimeout,
    Duration receiveTimeout = AppConstants.s3ReceiveTimeout,
    CancelToken? cancelToken,
  }) async {
    try {
      dynamic uploadData;
      int fileSize = 0;

      if (xFile != null) {
        fileSize = await xFile.length();
        if (kIsWeb) {
          uploadData = await xFile.readAsBytes();
        } else {
          uploadData = File(xFile.path).openRead();
        }
      } else if (fileBytes != null) {
        fileSize = fileBytes.length;
        uploadData = kIsWeb ? fileBytes : Stream.fromIterable([fileBytes]);
      } else {
        throw Exception('You must provide either fileBytes or xFile');
      }

      ///* Set headers
      final Map<String, dynamic> headers = {
        ApiKeys.contentTypeHeader: contentType,
        ApiKeys.contentLengthHeader: fileSize.toString(),
      };

      await _dio.put(
        url,
        data: uploadData,
        cancelToken: cancelToken,
        options: Options(
          headers: headers,
          sendTimeout: timeout,
          receiveTimeout: receiveTimeout,
          responseType: ResponseType.plain,
        ),
        onSendProgress: (count, total) {
          final actualTotal = total > 0 ? total : fileSize;
          if (kDebugMode) {
            print(
              '🚀 S3 Upload: ${(count / actualTotal * 100).toStringAsFixed(2)}%',
            );
          }
        },
      );
    } on DioException catch (e) {
      throw _handleS3Error(e);
    } catch (e) {
      throw ApiException(
        errorModel: ErrorModel(
          errorMessage: 'Unexpected error during S3 upload: $e',
        ),
      );
    }
  }

  //! Map DioException to a user-friendly error message
  ApiException _handleS3Error(DioException e) {
    final String message = (kIsWeb && e.error.toString().contains('TypeError'))
        ? 'Upload completed, but verification failed. Please refresh.'
        : switch (e.type) {
            DioExceptionType.connectionTimeout ||
            DioExceptionType.sendTimeout =>
              'Connection timed out. Please check your internet and try again.',
            DioExceptionType.receiveTimeout =>
              'Server is not responding. Please try again later.',
            DioExceptionType.badResponse => _mapS3StatusToMessage(
              e.response?.statusCode,
            ),
            DioExceptionType.cancel => 'Upload was cancelled.',
            DioExceptionType.connectionError =>
              'No internet connection. Please check your network.',
            _ => 'An unexpected error occurred. Please try again.',
          };

    return ApiException(
      errorModel: ErrorModel(
        errorMessage: message,
        statusCode: e.response?.statusCode,
      ),
    );
  }

  // Map HTTP status codes to readable messages
  String _mapS3StatusToMessage(int? statusCode) {
    return switch (statusCode) {
      403 => 'Access denied. Please re-select the file.',
      413 => 'Image is too large. Please choose a smaller file.',
      _ => 'Service unavailable (Error: $statusCode).',
    };
  }
}
