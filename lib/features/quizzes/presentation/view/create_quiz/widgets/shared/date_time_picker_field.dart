import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A read-only text field that triggers the date + time picker flow
/// when tapped. Displays the formatted [DateTime] string.
class DateTimePickerField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const DateTimePickerField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        style: AppStyles.mobileBodySmallMd.copyWith(
          color: AppColors.primaryDarkHover,
        ),
        decoration: InputDecoration(
          hintText: 'Pick date & time',
          hintStyle: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.whiteDarkHover,
          ),
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primaryDark,
          ),
        ),
        validator: (_) {
          if (controller.text.isEmpty) {
            return 'Start time is required';
          }
          return null;
        },
      ),
    );
  }
}
