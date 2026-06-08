import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/grade_column_model.dart';
import 'grade_row_model.dart';
import 'user_pagination_model.dart';

class GradeResponseModel {
  final String status;
  final List<GradeColumnModel> columns;
  final List<GradeRowModel> rows;
  final UserPaginationModel pagination;

  GradeResponseModel({
    required this.status,
    required this.columns,
    required this.rows,
    required this.pagination,
  });

  factory GradeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json[ApiKeys.data] as Map<String, dynamic>;

    return GradeResponseModel(
      status: json[ApiKeys.status] as String,
      columns: (data[ApiKeys.columns] as List)
          .map(
            (item) => GradeColumnModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      rows: (data[ApiKeys.rows] as List)
          .map((item) => GradeRowModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: UserPaginationModel.fromJson(json[ApiKeys.pagination]),
    );
  }

  // * ─── Computed Helpers ───

  /// Grade columns only (excludes ID and Name columns, i.e. columns without points).
  List<GradeColumnModel> get gradeColumns =>
      columns.where((c) => c.points != null).toList();

  /// Initial column visibility map derived from [columns] data (key → isVisible).
  /// Use this to seed mutable UI state; do NOT read it after the user has toggled visibility.
  Map<String, bool> get columnVisibility => {
    for (final col in columns)
      if (col.isVisible != null) col.key: col.isVisible!,
  };

  /// Filters [gradeColumns] based on a [visibilityFilter] string ('all' | 'visible' | 'hidden').
  /// Visibility is resolved from the [currentVisibility] map if provided, otherwise falls back to [columnVisibility].
  List<GradeColumnModel> filteredGradeColumns({
    required String visibilityFilter,
    Map<String, bool>? currentVisibility,
  }) {
    final visibilityMap = currentVisibility ?? columnVisibility;
    switch (visibilityFilter.toLowerCase()) {
      case 'visible':
        return gradeColumns.where((c) => visibilityMap[c.key] == true).toList();
      case 'hidden':
        return gradeColumns.where((c) => visibilityMap[c.key] != true).toList();
      default:
        return gradeColumns;
    }
  }

  GradeResponseModel copyWith({
    List<GradeColumnModel>? columns,
    List<GradeRowModel>? rows,
    UserPaginationModel? pagination,
  }) {
    return GradeResponseModel(
      status: status,
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      pagination: pagination ?? this.pagination,
    );
  }
}
