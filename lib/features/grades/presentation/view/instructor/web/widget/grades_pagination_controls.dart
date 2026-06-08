import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class GradesPaginationControls extends StatelessWidget {
  const GradesPaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalElements,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalElements;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

          if (isSmallScreen) {
            return Column(
              children: [
                _buildNavigationControls(),
                SizedBox(height: 12.h),
                _buildRowsPerPageControls(),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavigationControls(),
              _buildRowsPerPageControls(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationControls() {
    final hasPrevPage = currentPage > 1;
    final hasNextPage = currentPage < totalPages;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: hasPrevPage ? () => onPageChanged(currentPage - 1) : null,
        ),
        SizedBox(width: 8.w),
        _PageNumberBox(page: currentPage),
        SizedBox(width: 8.w),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          onTap: hasNextPage ? () => onPageChanged(currentPage + 1) : null,
        ),
        SizedBox(width: 12.w),
        Text(
          'of $totalPages pages',
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRowsPerPageControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Showing',
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(width: 8.w),
        _RowsPerPageSelector(
          currentSize: pageSize,
          onSelected: onPageSizeChanged,
        ),
        SizedBox(width: 8.w),
        Text(
          'items ($totalElements total)',
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
          width: 24,
          height: 24,
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
      width: 20,
      height: 24,
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
