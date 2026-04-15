import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/basic_information_section.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_header.dart';
import 'package:sams_app/features/materials/presentation/logic/manage_material_mixin.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/course_material_section.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/update_progress_overlay.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/uploading_overlay.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

class WebManageMaterialViewBody extends StatefulWidget {
  const WebManageMaterialViewBody({
    super.key,
    required this.isEditMode,
    required this.courseId,
  });

  final bool isEditMode;
  final String courseId;

  @override
  State<WebManageMaterialViewBody> createState() =>
      _WebManageMaterialViewBodyState();
}

class _WebManageMaterialViewBodyState extends State<WebManageMaterialViewBody>
    with ManageMaterialMixin {
  @override
  void initState() {
    super.initState();
    //* Critical: Initialize controllers with data if we are in Edit Mode
    final initialMaterial = context.read<MaterialCrudCubit>().initialMaterial;
    initializeControllers(initialMaterial);
  }

  @override
  void dispose() {
    disposeManageMaterial();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaterialCrudCubit, MaterialCrudState>(
      listenWhen: (previous, current) =>
          current is UpdateMaterialSuccess ||
          current is CreateMaterialSuccess ||
          current is CreateMaterialFailure ||
          current is UpdateMaterialFailure,
      listener: (context, state) {
        if (state is UpdateMaterialSuccess) {
          AppSnackBar.success(context, state.message);
          context.pop(state.material);
        } else if (state is CreateMaterialSuccess) {
          //* Return the created material and pop the view
          AppSnackBar.success(context, state.message);
          context.pop(state.material);
        } else if (state is CreateMaterialFailure) {
          AppSnackBar.error(context, state.errMessage);
        } else if (state is UpdateMaterialFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        //* Decouple various loading states for better UI control
        final isCreateLoading = state is CreateMaterialLoading;
        final isCreateUploading = isCreateLoading && state.isUploadingFiles;
        final isUpdateLoading = state is UpdateMaterialLoading;
        final anyLoading = isCreateLoading || isUpdateLoading;

        String updateMsg = '';
        if (state is UpdateMaterialLoading) {
          updateMsg = state.message;
        }

        return Stack(
          children: [
            IgnorePointer(
              ignoring: isCreateUploading || isUpdateLoading,
              child: Opacity(
                opacity: (isCreateUploading || isUpdateLoading) ? 0.3 : 1.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const WebHomeHeader(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
                        ),
                        child: Column(
                          children: [
                            _buildHeaderTitle(),
                            const SizedBox(height: 40),
                            _buildFormContent(),
                            const SizedBox(height: 50),
                            //* Prevent double submission by hiding the button during any loading state
                            if (!anyLoading) _buildSubmitButton(anyLoading),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //* Web Overlays behave exactly like Mobile for consistency
            if (isCreateUploading) const UploadingOverlay(),
            if (isUpdateLoading) UpdateProgressOverlay(message: updateMsg),
          ],
        );
      },
    );
  }

  Widget _buildHeaderTitle() {
    return Text(
      widget.isEditMode ? 'Edit Material' : 'Add Material',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFormContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: CustomBasicInformationSection(
              sectionTitle: 'Basic Information',
              fields: [
                InputFieldData(
                  label: 'Title',
                  hint: 'e.g. Chapter 1',
                  controller: titleController,
                ),
                InputFieldData(
                  label: 'Subtitle',
                  hint: 'e.g. Overview',
                  controller: subtitleController,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: CourseMaterialSection(
            key: materialSectionKey,
            //* Pass existing files for display when in edit mode
            initialItems: context
                .read<MaterialCrudCubit>()
                .initialMaterial
                ?.materialItems,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return CustomAppButton(
      width: 220,
      height: 50,
      borderRadius: 16,
      label: widget.isEditMode ? 'Edit Material' : 'Add Material',
      onPressed: isLoading
          ? null
          : () => onManageMaterialPressed(
              context: context,
              courseId: widget.courseId,
              isEditMode: widget.isEditMode,
            ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          : null,
    );
  }
}
