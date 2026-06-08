import 'package:sams_app/core/errors/models/error_model.dart';

abstract class AppException implements Exception {
  final ErrorModel errorModel;

  AppException({required this.errorModel});

  @override
  String toString() => errorModel.errorMessage;
}
