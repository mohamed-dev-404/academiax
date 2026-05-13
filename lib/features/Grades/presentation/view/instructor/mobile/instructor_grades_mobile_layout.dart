import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/mock/mock_instructor_grades.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/grades_import_export_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/instructor_grades_mobile_top_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/instructor_student_grade_card.dart';

/// ═══════════════════════════════════════════════════════════════
/// INSTRUCTOR — MOBILE LAYOUT
/// Card-based grades view for mobile screens.
/// No table — uses expandable cards per student.
/// ═══════════════════════════════════════════════════════════════
class InstructorGradesMobileLayout extends StatefulWidget {
  const InstructorGradesMobileLayout({super.key});

  @override
  State<InstructorGradesMobileLayout> createState() =>
      _InstructorGradesMobileLayoutState();
}

class _InstructorGradesMobileLayoutState
    extends State<InstructorGradesMobileLayout> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _displayedCount = 10;
  String _visibilityFilter = 'All';

  // Column visibility map
  late Map<String, bool> _columnVisibility;

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

  /// Delegates column filtering to the model.
  List<GradeColumnModel> get _filteredGradeColumns =>
      MockInstructorGrades.response.filteredGradeColumns(
        visibilityFilter: _visibilityFilter,
      );

  /// Filtered rows.
  List<GradeRowModel> get _filteredRows {
    if (_searchQuery.isEmpty) return MockInstructorGrades.rows;
    final query = _searchQuery.toLowerCase();
    return MockInstructorGrades.rows.where((row) {
      return row.student.name.toLowerCase().contains(query) ||
          row.student.academicId.toLowerCase().contains(query);
    }).toList();
  }

  /// Displayed rows (Lazy loading simulation).
  List<GradeRowModel> get _displayedRows {
    if (_displayedCount >= _filteredRows.length) return _filteredRows;
    return _filteredRows.sublist(0, _displayedCount);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ─── Top Bar ───
          InstructorGradesMobileTopBar(
            searchController: _searchController,
            onSearchChanged: (query) => setState(() {
              _searchQuery = query;
              _displayedCount = 10;
            }),
            visibilityFilter: _visibilityFilter,
            onFilterChanged: (filter) => setState(() {
              _visibilityFilter = filter;
              _displayedCount = 10;
            }),
            gradeColumns: MockInstructorGrades.response.gradeColumns,
            columnVisibility: _columnVisibility,
            onColumnVisibilityToggled: (key, isVis) {
              setState(() {
                _columnVisibility[key] = isVis;
              });
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GradesImportExportBar(
              onExport: () {},
              onImport: () {},
            ),
          ),

          // ─── Student Cards ───
          if (_filteredRows.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: GradesEmptyState(
                title: 'No students found',
                subtitle: 'Try a different search query',
              ),
            )
          else
            Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _displayedRows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return InstructorStudentGradeCard(
                      row: _displayedRows[index],
                      gradeColumns: _filteredGradeColumns,
                    );
                  },
                ),
                if (_displayedCount < _filteredRows.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _displayedCount += 10;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Load More',
                        style: AppStyles.mobileBodySmallMd,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
        ],
      ),
    );
  }
}
