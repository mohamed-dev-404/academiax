import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/presentation/view/instructor/shared/export_excel_button.dart';

/// Reusable filter bar for the instructor grades view.
/// Contains search, edit mode toggle, visibility filter, and action buttons.
class GradesFilterBar extends StatelessWidget {
  const GradesFilterBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.visibilityFilter,
    required this.onVisibilityFilterChanged,
    required this.courseId,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final String visibilityFilter; // 'all', 'visible', 'hidden'
  final ValueChanged<String> onVisibilityFilterChanged;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          //* Row 1: Search + Visibility filter
          Row(
            children: [
              // Visibility filter
              _VisibilityFilterChip(
                currentFilter: visibilityFilter,
                onChanged: onVisibilityFilterChanged,
              ),
              SizedBox(width: 12.w),

              // Search field
              Expanded(
                child: _SearchField(
                  controller: searchController,
                  onSubmitted: onSearch,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          //* Row 2: Export Button
          Row(
            children: [ExportExcelButton(courseId: courseId)],
          ),
        ],
      ),
    );
  }
}

/// Visibility filter chip (All / Visible / Hidden)
class _VisibilityFilterChip extends StatelessWidget {
  const _VisibilityFilterChip({
    required this.currentFilter,
    required this.onChanged,
  });
  final String currentFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: currentFilter,
      onSelected: onChanged,
      offset: const Offset(0, 42),
      color: AppColors.whiteLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.primaryLightHover),
      ),
      itemBuilder: (_) => [
        _buildMenuItem('all', 'All Columns', Icons.view_column_rounded),
        _buildMenuItem('visible', 'Visible Only', Icons.visibility_rounded),
        _buildMenuItem('hidden', 'Hidden Only', Icons.visibility_off_rounded),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              currentFilter == 'visible'
                  ? Icons.visibility_rounded
                  : currentFilter == 'hidden'
                  ? Icons.visibility_off_rounded
                  : Icons.filter_list_rounded,
              size: 16.sp.clamp(14, 18),
              color: AppColors.primaryDark,
            ),
            SizedBox(width: 6.w),
            Text(
              _getFilterLabel(),
              style: AppStyles.mobileBodyXsmallRg.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16.sp.clamp(14, 18),
              color: AppColors.whiteDarkActive,
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel() {
    switch (currentFilter) {
      case 'visible':
        return 'Visible';
      case 'hidden':
        return 'Hidden';
      default:
        return 'All';
    }
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppStyles.mobileBodySmallMd.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
        ],
      ),
    );
  }
}

/// Search field
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onSubmitted,
  });
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: AppStyles.mobileBodySmallRg.copyWith(
        color: AppColors.primaryDark,
      ),
      decoration: InputDecoration(
        hintText: 'Search by name or ID...',
        hintStyle: AppStyles.mobileBodySmallRg.copyWith(
          color: AppColors.whiteDarkHover,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.primary,
          size: 20.sp.clamp(18, 22),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 20.sp.clamp(18, 22),
          ),
          tooltip: 'Search',
          onPressed: () => onSubmitted(controller.text),
        ),
        filled: true,
        fillColor: AppColors.whiteLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
