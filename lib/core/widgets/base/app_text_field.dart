import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/validators/app_validators.dart';
import 'package:sams_app/core/widgets/base/text_field_error_builder.dart';

/// A customized [TextFormField] designed for high reusability across the app.
/// Handles validation logic, keyboard types, and dynamic sizing automatically.
class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextFieldType textFieldType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // Callbacks and interaction
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readOnly;

  // Formatting and Layout
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction; //Controls "Next" vs "Done" button

  const AppTextField({
    super.key,
    required this.hintText,
    required this.textFieldType,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.onTap,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    /* CRASH PREVENTION LOGIC:
       Flutter throws an error if minLines > maxLines. 
       We calculate 'effectiveMaxLines' to ensure the UI behaves predictably.
    */
    final effectiveMaxLines =
        maxLines ?? ((minLines != null && minLines! > 1) ? null : 1);
    /* Note: Setting maxLines to 'null' makes the field expand indefinitely 
       as the user types (ideal for description fields).
    */

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: effectiveMaxLines,
      minLines: minLines,

      // Selects keyboard layout based on field purpose and multiline status
      keyboardType: _getKeyboardType(effectiveMaxLines),

      // Defaults to 'next' to move to the next field, unless overridden
      textInputAction: textInputAction ?? TextInputAction.next,

      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        hintStyle:
            (SizeConfig.isMobile(context)
                    ? AppStyles.mobileBodyXsmallRg
                    : AppStyles.mobileLabelMediumRg)
                .copyWith(
                  color: AppColors.whiteDarkHover,
                ),

        // Ensures the hint text stays at the top when the field is tall
        alignLabelWithHint: true,
      ),

      // Custom error builder
      errorBuilder: (context, errorMessage) {
        return TextFieldErrorBuilder(
          errorMessage: errorMessage,
        );
      },

      // Centralized Switch-Case for validation based on the Enum
      validator: (value) {
        switch (textFieldType) {
          case TextFieldType.academicEmail:
            return AppValidators.validateAcademicEmail(value);
          case TextFieldType.numerical:
            return AppValidators.validateNumber(value);
          case TextFieldType.alphabetical:
            return AppValidators.validateName(value);
          case TextFieldType.normal:
            return AppValidators.validateNotEmpty(value);
        }
      },
    );
  }

  /// Determines the appropriate [TextInputType] for the user's keyboard.
  TextInputType _getKeyboardType(int? effectiveMaxLines) {
    // If the field is multiline (null or > 1), show the 'multiline' keyboard
    if (effectiveMaxLines == null || effectiveMaxLines > 1) {
      return TextInputType.multiline;
    }

    // Otherwise, match the keyboard to the expected data type
    switch (textFieldType) {
      case TextFieldType.numerical:
        return TextInputType.number;
      case TextFieldType.academicEmail:
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}
