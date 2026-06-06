import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/grades_search_field.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/mobile/widget/grades_filter_chip_bar.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/visibility_confirmation_dialog.dart';

class InstructorGradesMobileTopBar extends StatefulWidget {
  const InstructorGradesMobileTopBar({
    super.key,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.visibilityFilter,
    required this.onFilterChanged,
    required this.gradeColumns,
    required this.columnVisibility,
    required this.onColumnVisibilityToggled,
  });

  final TextEditingController searchController;
  final VoidCallback onSearchSubmitted;
  final String visibilityFilter;
  final ValueChanged<String> onFilterChanged;
  final List<GradeColumnModel> gradeColumns;
  final Map<String, bool> columnVisibility;
  final Function(String, bool) onColumnVisibilityToggled;

  @override
  State<InstructorGradesMobileTopBar> createState() =>
      _InstructorGradesMobileTopBarState();
}

class _InstructorGradesMobileTopBarState
    extends State<InstructorGradesMobileTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grades',
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),

              // Visibility quick toggle
              _buildVisibilityButton(),
            ],
          ),
          const SizedBox(height: 12),

          // Search
          GradesSearchField(
            controller: widget.searchController,
            onSubmitted: (_) => widget.onSearchSubmitted(),
            onSearchTap: widget.onSearchSubmitted,
            hintText: 'Search students...',
          ),
          const SizedBox(height: 12),

          // Visibility Filter Chips
          GradesFilterChipBar(
            filters: const ['All', 'Visible', 'Hidden'],
            selectedFilter: widget.visibilityFilter,
            onFilterChanged: widget.onFilterChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityButton() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 42),
      color: AppColors.whiteLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primaryLightHover),
      ),
      onSelected: (val) {
        // Toggle visibility for columns
      },
      itemBuilder: (_) => widget.gradeColumns.map((col) {
        final isVis = widget.columnVisibility[col.key] ?? true;
        return PopupMenuItem<String>(
          value: col.key,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            if (!mounted) return;
            final confirmed = await VisibilityConfirmationDialog.show(
              context: context,
              columnName: col.name,
              currentlyVisible: isVis,
              classworkId: col.key,
            );
            if (confirmed && mounted) {
              widget.onColumnVisibilityToggled(col.key, !isVis);
            }
          },
          child: Row(
            children: [
              Icon(
                isVis ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                size: 16,
                color: isVis ? AppColors.primary : AppColors.whiteDarkHover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  col.name,
                  style: AppStyles.mobileBodySmallRg.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          border: Border.all(color: AppColors.whiteHover),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.visibility_rounded,
              size: 14,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 4),
            Text(
              'Visible',
              style: AppStyles.mobileBodyXsmallRg.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
