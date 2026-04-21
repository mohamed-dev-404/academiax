import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/basic_information_section.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/logic/manage_material_mixin.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/course_material_section.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/manage_material_base_layout.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/manage_material_submit_button.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';

/// A stateful widget that provides the interface for creating or editing course materials.
/// It utilizes [ManageMaterialMixin] to handle form controllers and validation logic.
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
    //* Extract initial data from Cubit if in Edit Mode to pre-fill the form.
    final initialMaterial = context.read<MaterialCrudCubit>().initialMaterial;
    initializeControllers(initialMaterial);
  }

  @override
  void dispose() {
    //! Clean up controllers via mixin to prevent memory leaks.
    disposeManageMaterial();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //* Using shared BaseLayout to handle BlocConsumer, overlays, and interaction blocking.
    return ManageMaterialBaseLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFormSection(),
            const SizedBox(height: 16),
            CourseMaterialSection(
              key: materialSectionKey,
              initialItems: context
                  .read<MaterialCrudCubit>()
                  .initialMaterial
                  ?.materialItems,
            ),
            const SizedBox(height: 32),
            //* Shared Submission Button: Observes loading state and triggers validation.
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
    );
  }

  /// Constructs the text input fields for title and description using the provided mixin controllers.
  Widget _buildFormSection() {
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
            label: 'Description',
            hint: 'e.g. Overview',
            controller: descriptionController,
          ),
        ],
      ),
    );
  }
}
