import 'package:flutter/material.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';

//* Base state for Materials feature.
//* All Material states extend this class.
@immutable
sealed class MaterialFetchState {}

/// Initial state before any action.
final class MaterialFetchInitial extends MaterialFetchState {}

// --- Fetch List Section ---

//? Emitted while loading materials list.
final class MaterialFetchLoading extends MaterialFetchState {}

//* Emitted when materials list loaded successfully.
final class MaterialFetchSuccess extends MaterialFetchState {
  final List<MaterialModel> materials;
  MaterialFetchSuccess(this.materials);
}

//! Emitted when loading materials list fails.
final class MaterialFetchFailure extends MaterialFetchState {
  final String errMessage;
  MaterialFetchFailure(this.errMessage);
}

// --- Fetch Details Section ---

//* Base state for material details actions.
sealed class MaterialDetailsState extends MaterialFetchState {}

//? Emitted while loading specific material details.
final class MaterialDetailsFetchLoading extends MaterialDetailsState {}

//* Emitted when a single material's details are loaded successfully.
final class MaterialFetchDetailsSuccess extends MaterialDetailsState {
  final MaterialModel material;
  MaterialFetchDetailsSuccess(this.material);
}

//! Emitted when loading material details fails.
final class MaterialDetailsFetchFailure extends MaterialDetailsState {
  final String errMessage;
  MaterialDetailsFetchFailure(this.errMessage);
}
