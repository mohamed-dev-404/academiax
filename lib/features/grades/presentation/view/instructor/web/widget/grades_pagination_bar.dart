import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/user_pagination_model.dart';

/// Reusable pagination bar for grades tables.
/// Supports page navigation and items-per-page selection.
class GradesPaginationBar extends StatelessWidget {
  const GradesPaginationBar({
    super.key,
    required this.pagination,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  final UserPaginationModel pagination;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Page navigation
          _buildNavigationControls(),
          // Right: Items per page selector
          _buildRowsPerPageControls(),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Row(
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: pagination.hasPrevPage
              ? () => onPageChanged(pagination.currentPage - 1)
              : null,
        ),
        SizedBox(width: 8.w),
        _PageNumberBox(page: pagination.currentPage),
        SizedBox(width: 8.w),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          onTap: pagination.hasNextPage
              ? () => onPageChanged(pagination.currentPage + 1)
              : null,
        ),
        SizedBox(width: 12.w),
        Text(
          'of ${pagination.totalPages} pages',
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRowsPerPageControls() {
    return Row(
      children: [
        Text(
          'Showing',
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(width: 8.w),
        _RowsPerPageSelector(
          currentSize: pagination.size,
          onSelected: onPageSizeChanged,
        ),
        SizedBox(width: 8.w),
        Text(
          'items per page',
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: isDisabled ? AppColors.whiteHover : AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: isDisabled ? AppColors.whiteDark : AppColors.whiteLight,
            size: 20.sp.clamp(18, 22),
          ),
        ),
      ),
    );
  }
}

class _PageNumberBox extends StatelessWidget {
  const _PageNumberBox({required this.page});
  final int page;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 36.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        border: Border.all(color: AppColors.whiteDarkHover),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '$page',
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _RowsPerPageSelector extends StatelessWidget {
  const _RowsPerPageSelector({
    required this.currentSize,
    required this.onSelected,
  });
  final int currentSize;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: currentSize,
      onSelected: onSelected,
      offset: const Offset(0, 40),
      elevation: 4,
      color: AppColors.whiteLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.primaryLightHover),
      ),
      itemBuilder: (_) => [5, 10, 15, 20, 50]
          .map(
            (val) => PopupMenuItem<int>(
              value: val,
              height: 40.h,
              child: Center(
                child: Text(
                  '$val',
                  style: AppStyles.mobileBodyXsmallMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.whiteDarkHover),
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.whiteLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$currentSize',
              style: AppStyles.mobileTitleXsmallMd.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16.sp.clamp(16, 18),
              color: AppColors.whiteDarkActive,
            ),
          ],
        ),
      ),
    );
  }
}
