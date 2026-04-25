import 'package:sams_app/core/utils/constants/api_keys.dart';

class PaginationModel {
  final int totalElements;
  final int currentPage;
  final int size;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationModel({
    required this.totalElements,
    required this.currentPage,
    required this.size,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalElements: json[ApiKeys.totalElements],
      currentPage: json[ApiKeys.currentPage],
      size: json[ApiKeys.size],
      totalPages: json[ApiKeys.totalPages],
      hasNextPage: json[ApiKeys.hasNextPage],
      hasPrevPage: json[ApiKeys.hasPrevPage],
    );
  }
}