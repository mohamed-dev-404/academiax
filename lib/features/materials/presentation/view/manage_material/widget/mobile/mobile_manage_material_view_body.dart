import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/basic_information_section.dart';
import 'package:sams_app/features/materials/presentation/logic/manage_material_mixin.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/course_material_section.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/update_progress_overlay.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/uploading_overlay.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

class MobileManageMaterialViewBody extends StatefulWidget {
  const MobileManageMaterialViewBody({
    super.key,
    required this.isEditMode,
    required this.courseId,
  });

  final bool isEditMode;
  final String courseId;

  @override
  State<MobileManageMaterialViewBody> createState() =>
      _MobileManageMaterialViewBodyState();
}

class _MobileManageMaterialViewBodyState
    extends State<MobileManageMaterialViewBody>
    with ManageMaterialMixin {
  @override
  void initState() {
    super.initState();
    //* Retrieve initial material data for editing and initialize controllers
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
          //todo: Consider if we need to manually update MaterialFetchCubit list here or rely on parent refresh
          AppSnackBar.success(context, state.message);
          context.pop(state.material);
        } else if (state is CreateMaterialFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        //* Loading state evaluation
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
            //* Main content layer: partially hidden and disabled during heavy operations
            IgnorePointer(
              ignoring: isCreateUploading || isUpdateLoading,
              child: Opacity(
                opacity: (isCreateUploading || isUpdateLoading) ? 0.3 : 1.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      buildFormSection(),
                      const SizedBox(height: 16),
                      CourseMaterialSection(
                        key: materialSectionKey,
                        initialItems: context
                            .read<MaterialCrudCubit>()
                            .initialMaterial
                            ?.materialItems,
                      ),
                      const SizedBox(height: 32),
                      //* Submit Button - Hidden during loading to prevent double clicks
                      if (!anyLoading) buildActionButton(anyLoading),
                    ],
                  ),
                ),
              ),
            ),
            //* Full-screen Overlays for upload and update progress
            if (isCreateUploading) const UploadingOverlay(),
            if (isUpdateLoading) UpdateProgressOverlay(message: updateMsg),
          ],
        );
      },
    );
  }

  //* Builds the text input fields section
  Widget buildFormSection() {
    return Form(
      key: formKey,
      child: CustomBasicInformationSection(
        sectionTitle: 'Basic Information',
        fields: [
          InputFieldData(
            label: 'Title',
            hint: 'e.g. Ch 1',
            controller: titleController,
          ),
          InputFieldData(
            label: 'Subtitle',
            hint: 'e.g. Overview',
            controller: subtitleController,
          ),
        ],
      ),
    );
  }

  //* Logic for the main action button (Add/Edit)
  Widget buildActionButton(bool isLoading) {
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
              color: AppColors.whiteLight,
              strokeWidth: 2,
            )
          : null,
    );
  }
}
