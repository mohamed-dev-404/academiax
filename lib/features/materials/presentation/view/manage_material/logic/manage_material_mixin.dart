import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/course_material_section.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';

//* Mixin for manage material view logic and state management for both mobile and web
mixin ManageMaterialMixin<T extends StatefulWidget> on State<T> {
  //* Text controllers and keys
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<CourseMaterialSectionState> materialSectionKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //* Initialize controllers
  void initializeControllers(MaterialModel? initialMaterial) {
    if (initialMaterial != null) {
      titleController.text = initialMaterial.title;
      descriptionController.text = initialMaterial.description;
    }
  }

  //* Dispose controllers
  void disposeManageMaterial() {
    titleController.dispose();
    descriptionController.dispose();
  }

  //* Updated logic in ManageMaterialMixin
  void onManageMaterialPressed({
    required BuildContext context,
    required String courseId,
    required bool isEditMode,
  }) {
    if (!formKey.currentState!.validate()) return;

    final cubit = context.read<MaterialCrudCubit>();
    final newFiles = materialSectionKey.currentState?.allPickedFiles ?? [];

    // Get currently kept IDs to identify what was deleted
    final remainingIds =
        materialSectionKey.currentState?.remainingExistingIds ?? [];

    // Calculate keys to delete: Initial Keys - Remaining Keys
    final initialKeys =
        cubit.initialMaterial?.materialItems.map((e) => e.key ?? '').toList() ??
        [];
    final keysToDelete = initialKeys
        .where((id) => !remainingIds.contains(id))
        .toList();

    if (isEditMode) {
      //? Trigger Sequential Update Workflow
      cubit.updateMaterial(
        courseId: courseId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        keysToDelete: keysToDelete,
        newFiles: newFiles,
      );
    } else {
      //? Trigger Normal Creation Workflow
      cubit.createMaterial(
        courseId: courseId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        selectedFiles: newFiles,
      );
    }
  }
}
