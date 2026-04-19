import 'package:flutter/material.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';

/// A reusable UI section that dynamically generates a list of input fields.
/// It takes a [sectionTitle] and a list of [InputFieldData] to build the form content.
class MaterialBasicInfoSection extends StatelessWidget {
  const MaterialBasicInfoSection({
    super.key,
    required this.sectionTitle,
    required this.fields,
  });

  final String sectionTitle;
  final List<InputFieldData> fields;

  @override
  Widget build(BuildContext context) {
    //* Dynamic Mapping: Converts the data model list into a list of interactive UI tiles.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.whiteLight,
        border: Border.all(color: AppColors.secondary, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Section Header: Displays the main category title.
            _buildHeader(),
            const SizedBox(height: 16),
            //* Spread operator to inject the mapped list of input fields.
            ...fields.map((field) => _buildInputFieldTile(field)),
          ],
        ),
      ),
    );
  }

  /// Builds the header text with consistent project styling.
  Widget _buildHeader() {
    return Text(
      sectionTitle,
      style: AppStyles.mobileBodyLargeSb.copyWith(
        color: AppColors.primaryDarkHover,
      ),
    );
  }

  /// Builds a single labeled input field with consistent styling.
  /// Uses [InputFieldData] to maintain a clean method signature.
  Widget _buildInputFieldTile(InputFieldData field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TitledInputField(
        spacing: 2,
        label: field.label,
        labelStyle: AppStyles.mobileTitleXsmallMd.copyWith(
          color: AppColors.primaryDark,
        ),
        child: AppTextField(
          controller: field.controller,
          hintText: field.hint,
          textFieldType:
              field.type, //* Determines validation and keyboard logic.
        ),
      ),
    );
  }
}
