import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/data/model/update_material.request.dart';
import 'package:sams_app/features/materials/data/repos/material_repo.dart';
import 'package:sams_app/features/materials/presentation/logic/material_refresh_trigger.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

//* Handles Material operations: Create (Upload), Update, and Delete.
class MaterialCrudCubit extends Cubit<MaterialCrudState>
    with CubitMessageMixin, SafeEmitMixin {
  final MaterialRepo materialsRepo;
  final MaterialModel? initialMaterial;

  MaterialCrudCubit(this.materialsRepo, {this.initialMaterial})
    : super(MaterialCrudInitial());

  //* Full Workflow: Request Presigned URLs → S3 Upload → Backend Confirmation
  Future<void> createMaterial({
    required String courseId,
    required String title,
    required String description,
    required List<XFile> selectedFiles,
  }) async {
    // 1. Show loading state to block UI or show progress
    emit(CreateMaterialLoading(isUploadingFiles: selectedFiles.isNotEmpty));

    // 2. Execute the full workflow in the repository
    final result = await materialsRepo.uploadMaterialFullWorkflow(
      courseId: courseId,
      title: title,
      description: description,
      selectedFiles: selectedFiles,
    );

    result.fold(
      (failure) {
        // Show snackbar error message using mixin
        emitMessage(failure);
        emit(CreateMaterialFailure(failure));
      },
      (newMaterial) {
        // Success: Emit the newly created material to update the list later
        emit(
          CreateMaterialSuccess(
            material: newMaterial,
            message: 'Material added successfully!',
          ),
        );
      },
    );
  }

  //? --- 2. Sequential Update Workflow ---
  //* Execution Order: Update Metadata → Delete Items → Upload New Items
  Future<void> updateMaterial({
    required String courseId,
    required String title,
    required String description,
    required List<String> keysToDelete,
    required List<XFile> newFiles,
  }) async {
    final materialId = initialMaterial!.id;
    MaterialModel currentMaterial = initialMaterial!;

    //* PHASE 1: Update Material Metadata (Title & Description)
    emit(
      UpdateMaterialLoading(
        MaterialOperationType.saving,
        'Saving material info...',
      ),
    );
    final textUpdateResult = await materialsRepo.updateMaterial(
      materialId: materialId,
      request: UpdateMaterialRequest(title: title, description: description),
    );

    textUpdateResult.fold(
      (failure) =>
          null, //? Continue even if text update fails, or handle specifically if needed
      (updated) => currentMaterial = updated,
    );

    //* PHASE 2: Handle Item Deletions
    if (keysToDelete.isNotEmpty) {
      emit(
        UpdateMaterialLoading(
          MaterialOperationType.deleting,
          'Deleting selected files...',
        ),
      );
      for (var key in keysToDelete) {
        final result = await materialsRepo.deleteMaterialItem(
          materialId: materialId,
          itemKey: key,
        );

        result.fold(
          (failure) => null, //? Continue loop even if one item fails to delete
          (updated) => currentMaterial = updated,
        );
      }
    }

    //* PHASE 3: Handle New File Uploads
    if (newFiles.isNotEmpty) {
      emit(
        UpdateMaterialLoading(
          MaterialOperationType.uploading,
          'Uploading new files...',
        ),
      );

      final uploadResult = await materialsRepo.addItemsToMaterial(
        materialId: materialId,
        courseId: courseId,
        newFiles: newFiles,
      );

      uploadResult.fold(
        (failure) => emit(UpdateMaterialFailure(failure)),
        (updatedMaterial) {
          //* Notify listeners to refresh the list views
          MaterialRefreshTrigger.requestRefresh();
          emit(
            UpdateMaterialSuccess(
              material: updatedMaterial,
              message: 'All changes saved successfully!',
            ),
          );
        },
      );
    } else {
      //* Finalize operation if no new files were provided
      MaterialRefreshTrigger.requestRefresh();
      emit(
        UpdateMaterialSuccess(
          material: currentMaterial,
          message: 'Changes saved successfully!',
        ),
      );
    }
  }

  //! DELETE Entire Material
  Future<void> deleteMaterial({required String materialId}) async {
    emit(DeleteMaterialLoading());

    final result = await materialsRepo.deleteMaterial(materialId: materialId);

    result.fold(
      (failure) {
        emitMessage(failure); // Emit error via mixin for SnackBars
        emit(DeleteMaterialFailure(failure));
      },
      (_) {
        // Notify listeners to refresh lists across the application
        MaterialRefreshTrigger.requestRefresh();
        emit(DeleteMaterialSuccess('Material deleted successfully!'));
      },
    );
  }

  //?  Add New Items Only Workflow in floating button
  Future<void> addNewItemsOnly({
    required String materialId,
    required String courseId,
    required List<XFile> newFiles,
  }) async {
    if (newFiles.isEmpty) return;

    emit(
      AddMaterialItemsLoading(
        MaterialOperationType.uploading,
        'Uploading new files...',
      ),
    );

    final uploadResult = await materialsRepo.addItemsToMaterial(
      materialId: materialId,
      courseId: courseId,
      newFiles: newFiles,
    );

    uploadResult.fold(
      (failure) {
        emitMessage(failure);
        emit(AddMaterialItemsFailure(failure));
      },
      (updatedMaterial) {
        emit(
          AddMaterialItemsSuccess(
            material: updatedMaterial,
            message: 'Files added successfully!',
          ),
        );
      },
    );
  }

  //* Updates only Title and Description without touching files
  Future<void> updateMaterialMetadata({
    required String materialId,
    required String title,
    required String description,
  }) async {
    emit(
      UpdateMaterialLoading(
        MaterialOperationType.saving,
        'Saving material info...',
      ),
    );

    final result = await materialsRepo.updateMaterial(
      materialId: materialId,
      request: UpdateMaterialRequest(title: title, description: description),
    );

    result.fold(
      (failure) {
        emitMessage(failure); // Show error snackbar
        emit(UpdateMaterialFailure(failure));
      },
      (updatedMaterial) {
        // Notify listeners to refresh lists across the application
        MaterialRefreshTrigger.requestRefresh();
        emit(
          UpdateMaterialSuccess(
            material: updatedMaterial,
            message: 'Material info updated successfully!',
          ),
        );
      },
    );
  }

  //! DELETE Single Item from Material
  Future<void> deleteSingleItem({
    required String materialId,
    required String itemKey,
  }) async {
    emit(DeleteMaterialItemLoading());

    final result = await materialsRepo.deleteMaterialItem(
      materialId: materialId,
      itemKey: itemKey,
    );

    result.fold(
      (failure) {
        emitMessage(failure);
        emit(DeleteMaterialItemFailure(failure));
      },
      (updatedMaterial) {
        emit(
          DeleteMaterialItemSuccess(
            material: updatedMaterial,
            message: 'File removed successfully!',
          ),
        );
      },
    );
  }
}
