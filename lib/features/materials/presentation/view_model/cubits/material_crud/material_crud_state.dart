import 'package:flutter/material.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';

//* Define operation types to avoid string matching
enum MaterialOperationType { uploading, deleting, saving, general }

//* Base state for Material CRUD operations.
//* All Material states extend this class.
@immutable
sealed class MaterialCrudState {}

/// Initial state before any action.
final class MaterialCrudInitial extends MaterialCrudState {}

//* Base state for specific material actions.
//* Used for Create, Update, and Delete operations.
sealed class MaterialActionState extends MaterialCrudState {}

//? --- 1. Create Material States (Full Workflow) ---

//? Emitted while creating a new material (Post Material).
final class CreateMaterialLoading extends MaterialActionState {
  final bool isUploadingFiles;
  CreateMaterialLoading({this.isUploadingFiles = false});
}

//* Emitted when material created successfully and emits success message.
final class CreateMaterialSuccess extends MaterialActionState {
  final MaterialModel material;
  final String message;
  CreateMaterialSuccess({required this.material, required this.message});
}

//! Emitted when material creation fails and emits error message.
final class CreateMaterialFailure extends MaterialActionState {
  final String errMessage;
  CreateMaterialFailure(this.errMessage);
}

//? --- 2. Update Material States (Sequential Save) ---

//? Emitted while performing the multi-step update sequence.
final class UpdateMaterialLoading extends MaterialActionState {
  final MaterialOperationType operationType;
  final String message;
  UpdateMaterialLoading(this.operationType, this.message);
}

//* Emitted when all updates (Delete, Text, Upload) complete successfully.
final class UpdateMaterialSuccess extends MaterialActionState {
  final MaterialModel material;
  final String message;
  UpdateMaterialSuccess({required this.material, required this.message});
}

//! Emitted when any part of the update sequence fails.
final class UpdateMaterialFailure extends MaterialActionState {
  final String errMessage;
  UpdateMaterialFailure(this.errMessage);
}

//? --- 3. Add Items States (Standalone Request) ---

//? Emitted while adding new files to an existing material.
final class AddMaterialItemsLoading extends MaterialActionState {
  final MaterialOperationType operationType;
  final String message;
  AddMaterialItemsLoading(this.operationType, this.message);
}

//* Emitted when items added successfully.
final class AddMaterialItemsSuccess extends MaterialActionState {
  final MaterialModel material;
  final String message;
  AddMaterialItemsSuccess({required this.material, required this.message});
}

//! Emitted when adding items fails.
final class AddMaterialItemsFailure extends MaterialActionState {
  final String errMessage;
  AddMaterialItemsFailure(this.errMessage);
}

//? --- 4. Delete Material Item States (Standalone) ---

//? Emitted while deleting a single item from material.
final class DeleteMaterialItemLoading extends MaterialActionState {}

//* Emitted when item removed successfully.
final class DeleteMaterialItemSuccess extends MaterialActionState {
  final MaterialModel material;
  final String message;
  DeleteMaterialItemSuccess({required this.material, required this.message});
}

//! Emitted when removing item fails.
final class DeleteMaterialItemFailure extends MaterialActionState {
  final String errMessage;
  DeleteMaterialItemFailure(this.errMessage);
}

//? --- 5. Delete Entire Material States ---

//? Emitted while deleting an entire material.
final class DeleteMaterialLoading extends MaterialActionState {}

//* Emitted when material deleted successfully.
final class DeleteMaterialSuccess extends MaterialActionState {
  final String message;
  DeleteMaterialSuccess(this.message);
}

//! Emitted when deleting material fails.
final class DeleteMaterialFailure extends MaterialActionState {
  final String errMessage;
  DeleteMaterialFailure(this.errMessage);
}
