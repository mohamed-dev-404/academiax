import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';

class DurationInputField extends StatelessWidget {
  final TextEditingController controller;

  const DurationInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: controller,
          hintText: 'e.g. 30',
          textFieldType: TextFieldType.numerical,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'mins',
                  style: AppStyles.mobileBodySmallMd.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Helper subtext
        Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Access deadline. Students can start until the last minute and finish their full attempt.',
                style: AppStyles.mobileBodyXsmallRg.copyWith(
                  color: AppColors.whiteDarkActive,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
