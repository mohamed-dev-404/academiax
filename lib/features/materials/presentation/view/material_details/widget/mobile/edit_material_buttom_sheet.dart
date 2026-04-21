import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/logic/edit_material_mixin.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

/// Bottom sheet widget for editing material metadata.
/// It provides an interface for instructors to modify material details.
/// It is displayed on mobile devices.
class EditMaterialBottomSheet extends StatefulWidget {
  final MaterialModel material;

  const EditMaterialBottomSheet({super.key, required this.material});

  @override
  State<EditMaterialBottomSheet> createState() =>
      _EditMaterialBottomSheetState();
}

class _EditMaterialBottomSheetState extends State<EditMaterialBottomSheet>
    with EditMaterialMixin {
  @override
  MaterialModel get material => widget.material;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        //* Adjust bottom padding based on keyboard visibility to prevent overflow.
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 12,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Visual Handle: Indicates sheet is draggable.
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Edit Material Details',
                style: AppStyles.mobileTitleMediumSb.copyWith(
                  color: AppColors.primaryDarkHover,
                ),
              ),
              const SizedBox(height: 24),
              //* Material Input Fields
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
              //_ UX Tip: Guidance for instructors on effective metadata.
              Text(
                '• Provide a clear title and summary to help students recognize the content.',
                style: AppStyles.mobileBodyMediumRg.copyWith(
                  color: AppColors.primaryDark.withAlpha(180),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              //* Async Action Handling via BlocBuilder
              BlocBuilder<MaterialCrudCubit, MaterialCrudState>(
                builder: (context, state) {
                  //? Show loading indicator during the update request.
                  if (state is UpdateMaterialLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: CustomAppButton(
                          label: 'Cancel',
                          height: 45,
                          textColor: AppColors.primaryDark,
                          backgroundColor: AppColors.secondaryLight,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomAppButton(
                          label: 'Save',
                          height: 45,
                          //? handleUpdate is defined in EditMaterialMixin.
                          onPressed: () => handleUpdate(context),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
