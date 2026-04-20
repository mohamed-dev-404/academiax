import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A styled text field for entering question text.
///
/// Supports read-only mode and multi-line input.
class QuestionTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const QuestionTextField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.hintText = 'Enter your question here...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: null,
      minLines: 2,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      style: AppStyles.mobileBodySmallRg.copyWith(
        color: AppColors.blackDark,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.mobileBodySmallRg.copyWith(
          color: AppColors.whiteDarkHover,
        ),
        filled: true,
        fillColor: enabled ? AppColors.whiteLight : AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.whiteActive, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.whiteActive, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.whiteHover, width: 1),
        ),
      ),
    );
  }
}
