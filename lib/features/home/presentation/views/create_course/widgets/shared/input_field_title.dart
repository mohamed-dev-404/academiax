import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';

//* Generic input field with label and hint
class InputFieldTile extends StatelessWidget {
  final String label;
  final String hint;
  final TextFieldType textFieldType;
  final TextEditingController? controller;

  const InputFieldTile({
    super.key,
    required this.label,
    required this.hint,
    required this.textFieldType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TitledInputField(
        spacing: 2,
        label: label,
        labelStyle: AppStyles.mobileTitleXsmallMd.copyWith(
          color: AppColors.primaryDark,
        ),
        child: AppTextField(
          controller: controller,
          hintText: hint,
          textFieldType: textFieldType,
        ),
      ),
    );
  }
}
