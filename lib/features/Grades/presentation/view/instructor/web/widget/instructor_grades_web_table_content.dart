import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/web/widget/instructor_grades_web_table.dart';

class InstructorGradesWebTableContent extends StatelessWidget {
  const InstructorGradesWebTableContent({
    super.key,
    required this.rows,
    required this.columns,
    required this.columnVisibility,
    required this.onVisibilityChanged,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  final List<GradeRowModel> rows;
  final List<GradeColumnModel> columns;
  final Map<String, bool> columnVisibility;
  final void Function(String, bool) onVisibilityChanged;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int, bool) onSort;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (rows.isEmpty || columns.isEmpty) ? 300 : 52.h + (rows.length * 56.h) + 20.h,
      child: rows.isEmpty
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradesEmptyState(
                  title: 'No students found',
                  subtitle: 'Try a different search query',
                ),
              ],
            )
          : columns.isEmpty
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradesEmptyState(
                      title: 'No columns to display',
                      subtitle: 'Adjust your visibility filter or toggle columns',
                    ),
                  ],
                )
              : InstructorGradesWebTable(
              columns: columns,
              rows: rows,
              columnVisibility: columnVisibility,
              onVisibilityChanged: onVisibilityChanged,
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              onSort: onSort,
            ),
    );
  }
}
