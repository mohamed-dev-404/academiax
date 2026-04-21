import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/basic_information_section.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_header.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/logic/manage_material_mixin.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/course_material_section.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/manage_material_base_layout.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/manage_material_submit_button.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';

/// The Web implementation for managing materials (Create/Edit).
/// Adapts the form layout for larger screens while sharing logic with mobile via [ManageMaterialMixin].
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
    //* Critical: Initialize text controllers and internal state.
    //? If in Edit Mode, this populates fields with existing material data.
    final initialMaterial = context.read<MaterialCrudCubit>().initialMaterial;
    initializeControllers(initialMaterial);
  }

  @override
  void dispose() {
    //? Mixin cleanup to avoid memory leaks from TextControllers.
    disposeManageMaterial();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //* Unified BaseLayout handles state transitions and blocking overlays.
    return ManageMaterialBaseLayout(
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
                  //* Submission logic: Shared button observes loading state and handles triggers.
                  ManageMaterialSubmitButton(
                    isEditMode: widget.isEditMode,
                    onPressed: () => onManageMaterialPressed(
                      context: context,
                      courseId: widget.courseId,
                      isEditMode: widget.isEditMode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Renders the page title based on the current mode (Add vs Edit).
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

  /// Organizes the input form and material file section in a side-by-side [Row].
  Widget _buildFormContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Form(
            key: formKey, //? Mixed in from ManageMaterialMixin.
            child: CustomBasicInformationSection(
              sectionTitle: 'Basic Information',
              fields: [
                InputFieldData(
                  label: 'Title',
                  hint: 'e.g. Chapter 1',
                  controller: titleController,
                ),
                InputFieldData(
                  label: 'Description',
                  hint: 'e.g. Overview',
                  controller: descriptionController,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: CourseMaterialSection(
            key: materialSectionKey,
            //* Provides existing items to the file picker widget for editing.
            initialItems: context
                .read<MaterialCrudCubit>()
                .initialMaterial
                ?.materialItems,
          ),
        ),
      ],
    );
  }
}
