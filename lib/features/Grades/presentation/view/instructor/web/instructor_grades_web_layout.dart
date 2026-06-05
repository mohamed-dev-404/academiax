import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/grades_filter_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grade_error_widget.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/grades_pagination_controls.dart';
import 'package:sams_app/features/Grades/presentation/view_model/grade_cubit/grade_cubit.dart';

import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/instructor_grades_web_table_content.dart';

/// ═══════════════════════════════════════════════════════════════
/// INSTRUCTOR — WEB LAYOUT
/// Full table-based grades management view for web/desktop.
/// Features: sorting, visibility toggles, pagination.
/// ═══════════════════════════════════════════════════════════════
class InstructorGradesWebLayout extends StatefulWidget {
  const InstructorGradesWebLayout({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<InstructorGradesWebLayout> createState() =>
      _InstructorGradesWebLayoutState();
}

class _InstructorGradesWebLayoutState extends State<InstructorGradesWebLayout> {
  // ─── Local UI State (sorting & column visibility only) ───
  String _visibilityFilter = 'all';

  // Column visibility map (key → isVisible)
  Map<String, bool> _columnVisibility = {};

  // Sorting state
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // ─── Computed Data ───

  /// Delegates column filtering to the model.
  List<GradeColumnModel> _filteredGradeColumns(GradeCubit cubit) {
    final response = cubit.instructorGrades;
    if (response == null) return [];
    return response.filteredGradeColumns(
      visibilityFilter: _visibilityFilter,
      currentVisibility: _columnVisibility,
    );
  }

  /// Sorted rows — sorting is handled purely in UI.
  List<GradeRowModel> _sortedRows(GradeCubit cubit) {
    final response = cubit.instructorGrades;
    if (response == null) return [];
    final rows = response.rows;
    if (_sortColumnIndex == null) return rows;

    final filteredCols = _filteredGradeColumns(cubit);
    final sorted = List<GradeRowModel>.from(rows);
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
        if (gradeColIdx >= filteredCols.length) return 0;
        final col = filteredCols[gradeColIdx];
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GradeCubit>();

    return BlocBuilder<GradeCubit, GradeState>(
      buildWhen: (prev, curr) =>
          curr is GradeLoading ||
          curr is GradeLoadedSuccessfully ||
          curr is GradeLoadingFailed,
      builder: (context, state) {
        // ─── Full Loading (initial load) ───
        if (state is GradeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(64),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // ─── Error State ───
        if (state is GradeLoadingFailed) {
          return GradeErrorWidget(
            errorMessage: state.errorMessage,
            onRetry: () => cubit.getGradesForInstructor(),
          );
        }

        // ─── Loaded State ───
        final grades = cubit.instructorGrades;
        if (grades == null) return const SizedBox.shrink();

        // Initialize column visibility from server data on first load
        if (_columnVisibility.isEmpty) {
          _columnVisibility = Map<String, bool>.from(grades.columnVisibility);
        }

        final displayRows = _sortedRows(cubit);
        final filteredCols = _filteredGradeColumns(cubit);
        final pagination = grades.pagination;

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
                  searchController: cubit.searchController,
                  onSearch: (_) => cubit.onSearch(),
                  visibilityFilter: _visibilityFilter,
                  onVisibilityFilterChanged: (filter) =>
                      setState(() => _visibilityFilter = filter),
                  courseId: widget.courseId,
                ),
                SizedBox(height: 16.h),

                // ─── Table Section (rebuilds on GradeTableLoading) ───
                BlocBuilder<GradeCubit, GradeState>(
                  buildWhen: (prev, curr) =>
                      curr is GradeTableLoading ||
                      curr is GradeLoadedSuccessfully ||
                      curr is GradeLoadingFailed,
                  builder: (context, tableState) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: tableState is GradeTableLoading
                          ? const SizedBox(
                              key: ValueKey('table_loading'),
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            )
                          : InstructorGradesWebTableContent(
                              key: ValueKey(
                                '${pagination.currentPage}_${pagination.size}_${cubit.searchController.text}',
                              ),
                              rows: displayRows,
                              columns: filteredCols,
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
                              }),
                            ),
                    );
                  },
                ),

                // ─── Pagination ───
                const Divider(height: 1, color: AppColors.whiteHover),
                GradesPaginationControls(
                  currentPage: cubit.currentPage,
                  totalPages: pagination.totalPages,
                  pageSize: cubit.perPage,
                  totalElements: pagination.totalElements,
                  onPageChanged: (page) => cubit.onPageChanged(page),
                  onPageSizeChanged: (size) => cubit.onPageSizeChanged(size),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
