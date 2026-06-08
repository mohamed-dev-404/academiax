import 'package:sams_app/core/utils/constants/api_keys.dart';

class UserPaginationModel {
  final int totalElements;
  final int currentPage;
  final int size;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  UserPaginationModel({
    required this.totalElements,
    required this.currentPage,
    required this.size,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory UserPaginationModel.fromJson(Map<String, dynamic> json) {
    return UserPaginationModel(
      // Ensure you have these keys defined in your ApiKeys class
      totalElements: json[ApiKeys.totalElements] as int? ?? 0,
      currentPage: json[ApiKeys.currentPage] as int? ?? 1,
      size: json[ApiKeys.size] as int? ?? 10,
      totalPages: json[ApiKeys.totalPages] as int? ?? 1,
      hasNextPage: json[ApiKeys.hasNextPage] as bool? ?? false,
      hasPrevPage: json[ApiKeys.hasPrevPage] as bool? ?? false,
    );
  }

  /// Helper method to check if the list is empty
  bool get isEmpty => totalElements == 0;

  UserPaginationModel copyWith({
    int? totalElements,
    int? currentPage,
    int? size,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPrevPage,
  }) {
    return UserPaginationModel(
      totalElements: totalElements ?? this.totalElements,
      currentPage: currentPage ?? this.currentPage,
      size: size ?? this.size,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPrevPage: hasPrevPage ?? this.hasPrevPage,
    );
  }
}
