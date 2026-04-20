import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class WrittenQuestionWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String) onChanged;

  const WrittenQuestionWidget({
    super.key,
    this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 5,
      style: AppStyles.mobileBodySmallRg.copyWith(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Type your answer here...',
        hintStyle: const TextStyle(color: AppColors.whiteDark),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
