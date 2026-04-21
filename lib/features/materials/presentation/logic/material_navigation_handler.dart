import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/edit_material_buttom_sheet.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/add_material_items_dialog.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/delete_single_item_dialog.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/web/edit_material_dialog.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/file_preview_screen.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/video_player_screen.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/widget/shared/delete_material_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

/// A centralized navigator class for the Materials module.
/// Handles routing logic, Bloc state injection for dialogs, and platform-specific file opening.
class MaterialsNavigationHandler {
  /// Navigates to the details page and pre-fetches the specific material data.
  static void navigateToDetails(
    BuildContext context, {
    required String courseId,
    required MaterialModel material,
  }) {
    //* Pre-emptively fetch details to ensure data is ready when the view loads.
    context.read<MaterialFetchCubit>().fetchMaterialDetails(
      materialId: material.id,
    );
    context.push(
      RoutesName.materialDetails,
      extra: {
        'courseId': courseId,
        'materialId': material.id,
      },
    );
  }

  /// Opens the management screen to create a material and handles the returned result.
  static Future<void> navigateToManageMaterial(
    BuildContext context, {
    required String courseId,
  }) async {
    //? Capture Cubit reference before the async gap to ensure availability after pop.
    final fetchCubit = context.read<MaterialFetchCubit>();

    final result = await context.push(
      RoutesName.manageMaterial,
      extra: {
        'courseId': courseId,
        'initialMaterial': null,
      },
    );

    //* Update the list locally if a new material was successfully created.
    if (result is MaterialModel && context.mounted) {
      fetchCubit.addMaterialToListView(result);
    }
  }

  /// Displays the deletion dialog for a material category.
  static void showDeleteDialog(
    BuildContext context, {
    required MaterialModel material,
  }) {
    //! Re-inject the existing Cubit because showDialog creates a new route context.
    final materialCrudCubit = context.read<MaterialCrudCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: materialCrudCubit,
        child: DeleteMaterialDialog(
          materialId: material.id,
          materialName: material.title,
        ),
      ),
    );
  }

  /// Navigates to the edit screen and synchronizes the UI with the updated object.
  static Future<void> navigateToEditMaterial(
    BuildContext context, {
    required String courseId,
    required MaterialModel material,
  }) async {
    final fetchCubit = context.read<MaterialFetchCubit>();
    final result = await context.push(
      RoutesName.manageMaterial,
      extra: {
        'courseId': courseId,
        'initialMaterial': material,
      }, //? Pass existing object to populate the form fields.
    );

    if (result is MaterialModel && context.mounted) {
      //* Reflect the updated data in the details view immediately.
      fetchCubit.updateMaterialDetails(result);
    }
  }

  /// Shows the dialog to delete a specific item (video/file) from a material.
  static void showDeleteSingleItemDialog(
    BuildContext context, {
    required String materialId,
    required String itemKey,
    required String fileName,
  }) {
    final crudCubit = context.read<MaterialCrudCubit>();
    showDialog(
      context: context,
      builder: (dContext) => BlocProvider.value(
        value: crudCubit,
        child: DeleteSingleItemDialog(
          materialId: materialId,
          itemKey: itemKey,
          fileName: fileName,
        ),
      ),
    );
  }

  /// Determines how to open a material item based on its type and current platform.
  static void openMaterialItem(BuildContext context, MaterialItemModel item) {
    final String url = item.displayUrl ?? '';
    if (url.isEmpty) return;

    if (kIsWeb) {
      //? Web-specific: Open URLs in a new browser tab.
      launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
    } else {
      //* Mobile-specific: Route to internal preview/player screens.
      if (item.isVideoItem) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoUrl: url,
              videoTitle: item.originalFileName ?? 'Video',
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilePreviewScreen(
              url: url,
              fileName: item.originalFileName ?? 'File',
            ),
          ),
        );
      }
    }
  }

  /// Opens the dialog to add multiple files/videos to an existing material.
  static void showAddMaterialItemsDialog(
    BuildContext context, {
    required String courseId,
    required String materialId,
  }) {
    final crudCubit = context.read<MaterialCrudCubit>();
    final fetchCubit = context.read<MaterialFetchCubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          //! Inject both Cubits to allow the dialog to trigger CRUD and refresh data.
          BlocProvider.value(value: crudCubit),
          BlocProvider.value(value: fetchCubit),
        ],
        child: AddNewMaterialItemsDialog(
          courseId: courseId,
          materialId: materialId,
        ),
      ),
    );
  }

  /// Opens the dialog to edit a material title and description.
  static void showEdieMaterialDialog(
    BuildContext context, {
    required MaterialModel material,
    required String courseId,
  }) {
    final crudCubit = context.read<MaterialCrudCubit>();
    showDialog<void>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: crudCubit,
        child: EditMaterialDialog(
          courseId: courseId,
          material: material,
        ),
      ),
    );
  }

  /// Opens the Bottom Sheet to edit material metadata (Title & Description).
  static void showEditMaterialSheet(
    BuildContext context, {
    required MaterialModel material,
  }) {
    final crudCubit = context.read<MaterialCrudCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: crudCubit,
        child: EditMaterialBottomSheet(
          material: material,
        ),
      ),
    );
  }
}
