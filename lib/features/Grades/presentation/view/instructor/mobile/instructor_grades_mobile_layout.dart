import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grade_error_widget.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/grades_export_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/instructor_grades_mobile_top_bar.dart';
import 'package:sams_app/features/Grades/presentation/view_model/grade_cubit/grade_cubit.dart';

import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/instructor_grades_mobile_cards_content.dart';

/// ═══════════════════════════════════════════════════════════════
/// INSTRUCTOR — MOBILE LAYOUT
/// Card-based grades view for mobile screens.
/// No table — uses expandable cards per student.
/// ═══════════════════════════════════════════════════════════════
class InstructorGradesMobileLayout extends StatefulWidget {
  const InstructorGradesMobileLayout({super.key, required this.courseId});

  final String courseId;

  @override
  State<InstructorGradesMobileLayout> createState() =>
      _InstructorGradesMobileLayoutState();
}

class _InstructorGradesMobileLayoutState
    extends State<InstructorGradesMobileLayout> {
  // ─── Local UI State (column visibility filter only) ───
  String _visibilityFilter = 'All';

  // Column visibility map
  Map<String, bool> _columnVisibility = {};

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

        final rows = grades.rows;
        final filteredCols = _filteredGradeColumns(cubit);
        final pagination = grades.pagination;

        return SingleChildScrollView(
          child: Column(
            children: [
              // ─── Top Bar ───
              InstructorGradesMobileTopBar(
                searchController: cubit.searchController,
                onSearchSubmitted: () => cubit.onSearch(),
                visibilityFilter: _visibilityFilter,
                onFilterChanged: (filter) => setState(() {
                  _visibilityFilter = filter;
                }),
                gradeColumns: grades.gradeColumns,
                columnVisibility: _columnVisibility,
                onColumnVisibilityToggled: (key, isVis) {
                  setState(() {
                    _columnVisibility[key] = isVis;
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GradesExportBar(
                  courseId: widget.courseId,
                ),
              ),

              // ─── Student Cards Section (rebuilds on GradeTableLoading) ───
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
                            key: ValueKey('cards_loading'),
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        : InstructorGradesMobileCardsContent(
                            key: ValueKey(
                              '${pagination.currentPage}_${pagination.size}_${cubit.searchController.text}',
                            ),
                            rows: rows,
                            filteredCols: filteredCols,
                            pagination: pagination,
                            cubit: cubit,
                          ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
