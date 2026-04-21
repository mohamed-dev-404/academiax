import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

/// [MaterialDetailsHandler]
/// A centralized orchestration layer for material-related business logic and navigation.
///
/// Purpose:
/// - Segregates raw data for optimized UI rendering.
/// - Manages user interaction flows (Navigation, Deletion, Editing).
/// - Handles low-level external integrations (URL Launching).
class MaterialDetailsHandler {
  /// Categorizes a collection of material items into domain-specific buckets.
  ///
  /// Logic Flow:
  /// - Iterates through [materials] and evaluates the `isVideoItem` flag.
  /// - Facilitates distinct UI sections for high-bandwidth (Video) vs static (File) content.
  static Map<String, List<MaterialItemModel>> getCategorizedMaterials(
    List<MaterialItemModel> materials,
  ) {
    return {
      //* Filter Step: Isolate streamable video content for potential embedded player rendering.
      'videos': materials.where((item) => item.isVideoItem).toList(),

      //* Filter Step: Isolate static document assets (PDF, Images, ZIPs).
      'files': materials.where((item) => !item.isVideoItem).toList(),
    };
  }

  /// Entry point for handling material selection events.
  ///
  /// Implementation Detail:
  /// - Proxies the request to [MaterialsNavigationHandler] which selects the viewer
  ///   based on the item's MIME type or extension.
  static void onItemTap(BuildContext context, MaterialItemModel file) {
    //? Routing Decision: Injected via the Navigation Handler (Decoupled Logic).
    MaterialsNavigationHandler.openMaterialItem(context, file);
  }

  /// Initiates the destructive action workflow for a single file/video.
  ///
  /// Logic:
  /// - Invokes a UI Confirmation Dialog to prevent accidental triggers.
  /// - Identifies the object in S3 storage using the [itemKey].
  static void onDeleteItem(
    BuildContext context, {
    required String materialId,
    required MaterialItemModel item,
  }) {
    //_ UX Safety: Essential modal barrier for irreversible storage actions.
    MaterialsNavigationHandler.showDeleteSingleItemDialog(
      context,
      materialId: materialId,
      itemKey: item.key ?? '',
      fileName: item.originalFileName ?? 'Unknown File',
    );
  }

  /// Triggers the visual interface for updating material metadata.
  /// mobile 
  /// [material] represents the current state of the document being modified.
  static void onEditMaterialMobile(BuildContext context, MaterialModel material) {
    //_ Action: Delegates the Bottom Sheet/Dialog assembly to the Navigation Layer.
    MaterialsNavigationHandler.showEditMaterialSheet(
      context,
      material: material,
    );
  }
  
  /// Triggers the visual interface for updating material metadata.
  /// web  
  /// [material] represents the current state of the document being modified.
  static void onEditMaterialWeb(BuildContext context, MaterialModel material, String courseId) {
    //_ Action: Delegates the Bottom Sheet/Dialog assembly to the Navigation Layer.
    MaterialsNavigationHandler.showEdieMaterialDialog(
      context,
      material: material, courseId: courseId,
    );
  }

  /// Finalizes the deletion sequence by communicating with the Backend/State layer.
  ///
  /// Execution Context:
  /// - Called only after user confirmation from the Delete Dialog.
  static void confirmDeleteSingleItem(
    BuildContext context, {
    required String materialId,
    required String itemKey,
  }) {
    //* State Injection: Trigger the Bloc/Cubit event to update the remote database.
    context.read<MaterialCrudCubit>().deleteSingleItem(
      materialId: materialId,
      itemKey: itemKey,
    );
  }

  /// Robust utility for launching external resources (Browser or Native Apps).
  ///
  /// Features:
  /// - Built-in URL validation ([canLaunchUrl]).
  /// - Context-aware Error Handling: Shows a [SnackBar] if the operation fails.
  /// - Support for different [LaunchMode] strategies (In-app vs External).
  static Future<void> launchExternalUrl(
    BuildContext context,
    String url, {
    required LaunchMode mode,
  }) async {
    final Uri uri = Uri.parse(url);

    //? Pre-flight check: Verify system capability to handle the URI.
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    } else {
      //_ Fallback: Provide immediate visual feedback to the user on failure.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the file')),
        );
      }
    }
  }
}
