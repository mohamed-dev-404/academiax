import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';

/// Mixin providing shared logic for editing material metadata across different UI representations (Dialogs/Sheets).
mixin EditMaterialMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Abstract getter to access the target material model from the implementing State class.
  MaterialModel get material;

  @override
  void initState() {
    super.initState();
    //* Initialize controllers with existing data for editing.
    titleController = TextEditingController(text: material.title);
    descriptionController = TextEditingController(text: material.description);
  }

  @override
  void dispose() {
    //* Resource cleanup to prevent memory leaks.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  /// Processes the update request by validating input and checking for data mutations.
  void handleUpdate(BuildContext context) {
    //* 1. Trigger form validation.
    if (!formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    //? Logic: Compare current input with original data to avoid redundant API calls.
    final bool isChanged =
        title != material.title || description != material.description;

    if (isChanged && title.isNotEmpty) {
      //* Dispatch update event to MaterialCrudCubit.
      context.read<MaterialCrudCubit>().updateMaterialMetadata(
            materialId: material.id,
            title: title,
            description: description,
          );
    } else {
      //_ No changes detected: Dismiss UI immediately.
      Navigator.pop(context);
    }
  }
}