import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// Reusable search field for grades filtering.
class GradesSearchField extends StatelessWidget {
  const GradesSearchField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onSearchTap,
    this.hintText = 'Search by name or ID...',
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchTap;
  final String hintText;

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
        hintText: hintText,
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
          onPressed: onSearchTap,
        ),
        filled: true,
        fillColor: AppColors.whiteLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.whiteHover),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.whiteHover),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
