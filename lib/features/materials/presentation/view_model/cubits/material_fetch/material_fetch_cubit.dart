import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/data/repos/material_repo.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

//* Manages material-related states: Fetching collections and individual details
class MaterialFetchCubit extends Cubit<MaterialFetchState>
    with CubitMessageMixin, SafeEmitMixin {
  final MaterialRepo materialsRepo;

  MaterialFetchCubit(this.materialsRepo) : super(MaterialFetchInitial());

  //* Implements "Cache-then-Network" strategy for better UX
  //* Provides instant feedback via cache while fetching fresh data from the API
  Future<void> fetchMaterials({required String courseId}) async {
    // 1. PHASE: Immediate feedback from local cache
    final cachedMaterials = materialsRepo.getCachedMaterials();

    if (cachedMaterials.isNotEmpty) {
      emit(MaterialFetchSuccess(cachedMaterials));
    } else {
      // 2. PHASE: Fallback to loading indicator if cache is empty
      emit(MaterialFetchLoading());
    }

    // 3. PHASE: Remote data synchronization
    final result = await materialsRepo.fetchMaterials(courseId: courseId);

    result.fold(
      (failure) {
        //* Error Handling: If data is already on screen, show a message instead of an error view
        if (state is MaterialFetchSuccess) {
          emitMessage(failure);
        } else {
          emit(MaterialFetchFailure(failure));
        }
      },
      //* Update UI with the latest synchronized data
      (materials) => emit(MaterialFetchSuccess(materials)),
    );
  }

  //* Fetch comprehensive details for a specific material resource
  Future<void> fetchMaterialDetails({required String materialId}) async {
    emit(MaterialDetailsFetchLoading());

    final result = await materialsRepo.fetchMaterialDetails(
      materialId: materialId,
    );

    result.fold(
      (failure) => emit(MaterialDetailsFetchFailure(failure)),
      (material) => emit(MaterialFetchDetailsSuccess(material)),
    );
  }

  //* Reactive UI: Prepend a new material to the list locally for zero-latency feedback
  void addMaterialToListView(MaterialModel newMaterial) {
    if (state is MaterialFetchSuccess) {
      final currentList = (state as MaterialFetchSuccess).materials;

      // Ensure the new item appears first in the sequence
      final updatedList = [newMaterial, ...currentList];
      emit(MaterialFetchSuccess(updatedList));
    } else {
      // Initialize list with the new material if state was empty or loading
      emit(MaterialFetchSuccess([newMaterial]));
    }
  }

  //* Reactive UI: Synchronize list state locally after a deletion operation
  void removeMaterialFromList(String materialId) {
    if (state is MaterialFetchSuccess) {
      final currentList = (state as MaterialFetchSuccess).materials;
      final updatedList = currentList.where((m) => m.id != materialId).toList();
      emit(MaterialFetchSuccess(updatedList));
    }
  }

  //* Reactive UI: Update specific item properties in the current list view
  void updateMaterialInList(MaterialModel updatedMaterial) {
    if (state is MaterialFetchSuccess) {
      final currentList = (state as MaterialFetchSuccess).materials;
      final updatedList = currentList
          .map((m) => m.id == updatedMaterial.id ? updatedMaterial : m)
          .toList();
      emit(MaterialFetchSuccess(updatedList));
    }
  }

  //* Combined Synchronization: Updates the item in the list and the details view simultaneously
  void updateMaterialDetails(MaterialModel updatedMaterial) {
    updateMaterialInList(updatedMaterial);
    emit(MaterialFetchDetailsSuccess(updatedMaterial));
  }
}
