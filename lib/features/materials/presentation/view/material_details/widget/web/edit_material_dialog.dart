import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/logic/edit_material_mixin.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

/// Dialog widget for editing material metadata, primarily used in Tablet/Web layouts.
/// It provides an interface for instructors to modify material details.
/// It is displayed on Tablet/Web devices.
class EditMaterialDialog extends StatefulWidget {
  final MaterialModel material;
  final String courseId;

  const EditMaterialDialog({
    super.key,
    required this.courseId,
    required this.material,
  });

  @override
  State<EditMaterialDialog> createState() => _EditMaterialDialogState();
}

class _EditMaterialDialogState extends State<EditMaterialDialog>
    with EditMaterialMixin {
  @override
  MaterialModel get material => widget.material;

  @override
  Widget build(BuildContext context) {
    //* Dynamic width calculation based on device form factor.
    double dialogWidth = SizeConfig.isMobile(context)
        ? MediaQuery.sizeOf(context).width
        : 450;

    return AlertDialog(
      backgroundColor: AppColors.whiteLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Center(child: Text('Edit Material Details')),
      titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
        color: AppColors.primaryDarkHover,
      ),
      content: Container(
        width: dialogWidth,
        constraints: const BoxConstraints(maxWidth: 450),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Input section for Material metadata.
              AppTextField(
                prefixIcon: const Icon(Icons.drive_file_rename_outline),
                hintText: 'Material Title',
                textFieldType: TextFieldType.normal,
                controller: titleController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                prefixIcon: const Icon(Icons.description_outlined),
                hintText: 'Description',
                textFieldType: TextFieldType.normal,
                controller: descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              //_ Helper text to maintain data quality standards.
              Text(
                '• Use a descriptive title and summary to help students find their resources easily.',
                style: AppStyles.mobileBodyMediumRg.copyWith(
                  color: AppColors.primaryDark.withAlpha(180),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      actions: [
        //* Reactive Action Bar: Handles loading and submission states.
        BlocBuilder<MaterialCrudCubit, MaterialCrudState>(
          builder: (context, state) {
            if (state is UpdateMaterialLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              );
            }
            return Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    label: 'Cancel',
                    height: 40,
                    textColor: AppColors.primaryDark,
                    backgroundColor: AppColors.secondaryLight,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomAppButton(
                    textColor: AppColors.whiteLight,
                    height: 40,
                    label: 'Save',
                    //? handleUpdate logic provided by EditMaterialMixin.
                    onPressed: () => handleUpdate(context),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
