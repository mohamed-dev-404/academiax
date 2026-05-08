import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_instructor_grades.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/grades_filter_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/instructor_grades_web_table.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/grades_pagination_controls.dart';

/// ═══════════════════════════════════════════════════════════════
/// INSTRUCTOR — WEB LAYOUT
/// Full table-based grades management view for web/desktop.
/// Features: sorting, visibility toggles, pagination.
/// ═══════════════════════════════════════════════════════════════
class InstructorGradesWebLayout extends StatefulWidget {
  const InstructorGradesWebLayout({super.key});

  @override
  State<InstructorGradesWebLayout> createState() =>
      _InstructorGradesWebLayoutState();
}

class _InstructorGradesWebLayoutState extends State<InstructorGradesWebLayout> {
  // ─── Local UI State ───
  final TextEditingController _searchController = TextEditingController();

  String _visibilityFilter = 'all';
  String _searchQuery = '';

  int _currentPage = 1;
  int _pageSize = 10;

  // Column visibility map (key → isVisible)
  late Map<String, bool> _columnVisibility;

  // Sorting state
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _columnVisibility = {
      for (final col in MockInstructorGrades.columns)
        if (col.isVisible != null) col.key: col.isVisible!,
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── Computed Data ───

  /// Get grade columns (excluding ID and Name).
  List<GradeColumnModel> get _gradeColumns =>
      MockInstructorGrades.columns.where((c) => c.points != null).toList();

  /// Filter columns based on visibility filter.
  List<GradeColumnModel> get _filteredGradeColumns {
    switch (_visibilityFilter.toLowerCase()) {
      case 'visible':
        return _gradeColumns
            .where((c) => _columnVisibility[c.key] == true)
            .toList();
      case 'hidden':
        return _gradeColumns
            .where((c) => _columnVisibility[c.key] != true)
            .toList();
      default:
        return _gradeColumns;
    }
  }

  /// Filter rows based on search query.
  List<GradeRowModel> get _filteredRows {
    if (_searchQuery.isEmpty) return MockInstructorGrades.rows;
    final query = _searchQuery.toLowerCase();
    return MockInstructorGrades.rows.where((row) {
      return row.student.name.toLowerCase().contains(query) ||
          row.student.academicId.toLowerCase().contains(query);
    }).toList();
  }

  /// Paginated rows.
  List<GradeRowModel> get _paginatedRows {
    final start = (_currentPage - 1) * _pageSize;
    final end = start + _pageSize;
    if (start >= _filteredRows.length) return [];
    return _filteredRows.sublist(
      start,
      end > _filteredRows.length ? _filteredRows.length : end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ───
            Text(
              'Students Grades',
              style: AppStyles.mobileTitleMediumSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(height: 16.h),

            // ─── Filters Bar ───
            GradesFilterBar(
              searchController: _searchController,
              onSearch: (query) => setState(() {
                _searchQuery = query;
                _currentPage = 1;
              }),
              visibilityFilter: _visibilityFilter,
              onVisibilityFilterChanged: (filter) =>
                  setState(() => _visibilityFilter = filter),
              onExport: () {},
              onImport: () {},
            ),
            SizedBox(height: 16.h),

            // ─── Table ───
            SizedBox(
              height: _paginatedRows.isEmpty
                  ? 300
                  : 52.h + (_paginatedRows.length * 56.h) + 20.h,
              child: _paginatedRows.isEmpty
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradesEmptyState(
                          title: 'No students found',
                          subtitle: 'Try a different search query',
                        ),
                      ],
                    )
                  : InstructorGradesWebTable(
                      columns: _filteredGradeColumns,
                      rows: _paginatedRows,
                      columnVisibility: _columnVisibility,
                      onVisibilityChanged: (key, isVis) => setState(() {
                        _columnVisibility[key] = isVis;
                      }),
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      onSort: (idx, asc) => setState(() {
                        _sortColumnIndex = idx;
                        _sortAscending = asc;
                      }),
                    ),
            ),

            // ─── Pagination ───
            const Divider(height: 1, color: AppColors.whiteHover),
            GradesPaginationControls(
              currentPage: _currentPage,
              totalPages: (_filteredRows.length / _pageSize).ceil() == 0
                  ? 1
                  : (_filteredRows.length / _pageSize).ceil(),
              pageSize: _pageSize,
              totalElements: _filteredRows.length,
              onPageChanged: (page) => setState(() => _currentPage = page),
              onPageSizeChanged: (size) => setState(() {
                _pageSize = size;
                _currentPage = 1;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
