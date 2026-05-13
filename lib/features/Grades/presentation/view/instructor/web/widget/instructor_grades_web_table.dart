import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/Grades/presentation/view/widget/web/grade_cell.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/visibility_confirmation_dialog.dart';

class InstructorGradesWebTable extends StatelessWidget {
  const InstructorGradesWebTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.columnVisibility,
    required this.onVisibilityChanged,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  final List<GradeColumnModel> columns;
  final List<GradeRowModel> rows;
  final Map<String, bool> columnVisibility;
  final Function(String key, bool isVisible) onVisibilityChanged;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int index, bool ascending) onSort;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 26,
      horizontalMargin: 12,
      minWidth: 600 + (columns.length * 120).toDouble(),
      headingRowHeight: 52.h,
      dataRowHeight: 56.h,
      headingRowColor: WidgetStateProperty.all(AppColors.primary),
      headingTextStyle: AppStyles.mobileBodyXsmallMd.copyWith(
        color: Colors.white,
      ),
      // Sort arrow is handled entirely by our custom label widgets
      // (AnimatedSwitcher inside _SortableHeader / _buildGradeColumnHeader),
      // so we disable the package’s built-in arrow to avoid layout shifts.
      scrollController: ScrollController(),
      columns: _buildColumns(context),
      rows: rows.asMap().entries.map((e) => _buildRow(e.value, e.key)).toList(),
    );
  }

  List<DataColumn2> _buildColumns(BuildContext context) {
    return [
      DataColumn2(
        label: _SortableHeader(
          title: 'ID',
          index: 0,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
        ),
        size: ColumnSize.S,
        fixedWidth: 120.w,
        onSort: onSort,
      ),
      DataColumn2(
        label: _SortableHeader(
          title: 'Name',
          index: 1,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
        ),
        size: ColumnSize.L,
        fixedWidth: 250.w,
        onSort: onSort,
      ),
      ...columns.asMap().entries.map((entry) {
        return DataColumn2(
          label: _buildGradeColumnHeader(context, entry.value, 2 + entry.key),
          size: ColumnSize.M,
          onSort: onSort,
        );
      }),
    ];
  }

  Widget _buildGradeColumnHeader(
    BuildContext context,
    GradeColumnModel col,
    int colIndex,
  ) {
    final isVisible = columnVisibility[col.key] ?? true;
    final isActive = sortColumnIndex == colIndex;

    // Determine which icon to show — always in the same slot so layout never shifts.
    final IconData sortIcon = isActive
        ? (sortAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
        : Icons.swap_vert_rounded;
    final Color sortIconColor = isActive
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.4);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                col.name,
                style: AppStyles.mobileBodyXsmallMd.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Fixed-size slot — icon animates in place, no layout shift.
            SizedBox(width: 2.w),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: Icon(
                sortIcon,
                key: ValueKey(sortIcon),
                size: 12.sp,
                color: sortIconColor,
              ),
            ),
            SizedBox(width: 4.w),
            InkWell(
              onTap: () async {
                final confirmed = await VisibilityConfirmationDialog.show(
                  context: context,
                  columnName: col.name,
                  currentlyVisible: isVisible,
                );
                if (confirmed) {
                  onVisibilityChanged(col.key, !isVisible);
                }
              },
              child: Icon(
                isVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 14.sp.clamp(12, 16),
                color: isVisible
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        if (col.points != null)
          Text(
            '/ ${col.points}',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10.sp.clamp(9, 12),
            ),
          ),
      ],
    );
  }

  DataRow2 _buildRow(GradeRowModel row, int index) {
    final cellStyle = AppStyles.mobileBodySmallRg.copyWith(
      color: AppColors.primaryDark,
    );

    return DataRow2(
      color: WidgetStateProperty.all(
        index.isEven ? AppColors.white : AppColors.whiteHover,
      ),
      cells: [
        DataCell(Text(row.student.academicId, style: cellStyle)),
        DataCell(
          Text(
            row.student.name,
            style: cellStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ...columns.map((col) {
          final score = row.grades[col.key];
          return DataCell(
            GradeCell(
              score: score,
              maxScore: col.points,
            ),
          );
        }),
      ],
    );
  }
}

/// Header label for plain sortable columns (ID, Name).
/// Always renders the sort icon in the same fixed slot — no layout shift.
/// Uses [AnimatedSwitcher] to smoothly cross-fade between:
///   • [swap_vert]       — column is not the active sort column
///   • [arrow_upward]   — active, ascending
///   • [arrow_downward] — active, descending
class _SortableHeader extends StatelessWidget {
  final String title;

  /// This column’s positional index in the table (0 = ID, 1 = Name, ...).
  final int index;

  /// Active sort column index from the parent. Null → no column sorted yet.
  final int? sortColumnIndex;

  /// Current sort direction — only meaningful when [sortColumnIndex] == [index].
  final bool sortAscending;

  const _SortableHeader({
    required this.title,
    required this.index,
    required this.sortColumnIndex,
    required this.sortAscending,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = sortColumnIndex == index;
    final IconData sortIcon = isActive
        ? (sortAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
        : Icons.swap_vert_rounded;
    final Color sortIconColor = isActive
        ? Colors.white.withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.4);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        SizedBox(width: 4.w),
        // Fixed slot — always here, icon swaps smoothly.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: Icon(
            sortIcon,
            key: ValueKey(sortIcon),
            size: 14.sp,
            color: sortIconColor,
          ),
        ),
      ],
    );
  }
}