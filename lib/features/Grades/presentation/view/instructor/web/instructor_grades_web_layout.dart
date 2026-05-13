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
    _columnVisibility = MockInstructorGrades.response.columnVisibility;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── Computed Data ───

  /// Delegates column filtering to the model.
  List<GradeColumnModel> get _filteredGradeColumns =>
      MockInstructorGrades.response.filteredGradeColumns(
        visibilityFilter: _visibilityFilter,
      );

  // ! Filter rows based on search query.(will be handle by request)
  List<GradeRowModel> get _filteredRows {
    if (_searchQuery.isEmpty) return MockInstructorGrades.rows;
    final query = _searchQuery.toLowerCase();
    return MockInstructorGrades.rows.where((row) {
      return row.student.name.toLowerCase().contains(query) ||
          row.student.academicId.toLowerCase().contains(query);
    }).toList();
  }

  // TODO: Sorted rows. (Review and understand its logic carefully)
  List<GradeRowModel> get _sortedRows {
    if (_sortColumnIndex == null) return _filteredRows;
    final sorted = List<GradeRowModel>.from(_filteredRows);
    sorted.sort((a, b) {
      int cmp;
      if (_sortColumnIndex == 0) {
        // Sort by student ID
        cmp = a.student.academicId.compareTo(b.student.academicId);
      } else if (_sortColumnIndex == 1) {
        // Sort by student name
        cmp = a.student.name.compareTo(b.student.name);
      } else {
        // Sort by grade score — null scores sink to the bottom
        final gradeColIdx = _sortColumnIndex! - 2;
        if (gradeColIdx >= _filteredGradeColumns.length) return 0;
        final col = _filteredGradeColumns[gradeColIdx];
        final aScore = a.grades[col.key];
        final bScore = b.grades[col.key];
        if (aScore == null && bScore == null) return 0;
        if (aScore == null) return 1;
        if (bScore == null) return -1;
        cmp = (aScore as num).compareTo(bScore as num);
      }
      return _sortAscending ? cmp : -cmp;
    });
    return sorted;
  }

  // ! Paginated rows. (will be handle by request)
  List<GradeRowModel> get _paginatedRows {
    final start = (_currentPage - 1) * _pageSize;
    final end = start + _pageSize;
    if (start >= _sortedRows.length) return [];
    return _sortedRows.sublist(
      start,
      end > _sortedRows.length ? _sortedRows.length : end,
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
              onExport: () {
                // TODO: implement export logic
              },
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
                      onSort: (idx, _) => setState(() {
                        if (_sortColumnIndex == idx) {
                          // Same column → toggle direction
                          _sortAscending = !_sortAscending;
                        } else {
                          // New column → switch and reset to ascending
                          _sortColumnIndex = idx;
                          _sortAscending = true;
                        }
                        _currentPage = 1;
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
