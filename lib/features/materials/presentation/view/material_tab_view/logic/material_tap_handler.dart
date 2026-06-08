// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// Managed UI logic for the Materials Tab View.
/// Handles context menu positioning and coordinates actions between the UI and Navigation.
class MaterialTabHandler {
  /// Calculates and displays the context menu relative to the tapped card.
  /// Works for both Mobile and Web by using the anchorContext to find screen coordinates.
  static void showMaterialActionsMenu({
    required BuildContext context,
    required BuildContext anchorContext,
    required MaterialModel material,
    required String courseId,
  }) async {
    //* Logic: Identify the position of the specific card in the global coordinate space.
    final RenderBox button = anchorContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width, 0), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    //* Interaction: Display the popup menu with standardized styling.
    final String? selected = await showMenu<String>(
      context: context,
      position: position,
      color: AppColors.whiteLight,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        _buildMenuItem(
          value: 'edit',
          icon: Icons.edit,
          text: 'Edit',
          color: AppColors.primary,
        ),
        _buildMenuItem(
          value: 'delete',
          icon: Icons.delete_outline,
          text: 'Delete',
          color: Colors.red,
        ),
      ],
    );

    if (selected == null) return;

    //* Execution: Trigger the appropriate navigation or dialog logic.
    if (selected == 'delete' && context.mounted) {
      MaterialsNavigationHandler.showDeleteDialog(context, material: material);
    } else if (selected == 'edit' && context.mounted) {
      //* Start the specialized edit flow to ensure data integrity
      _handleEditAction(
        context: context,
        material: material,
        courseId: courseId,
      );
    }
  }

  /// Manages the full edit lifecycle: Loading -> Fetching -> Syncing -> Navigation.
  static void _handleEditAction({
    required BuildContext context,
    required MaterialModel material,
    required String courseId,
  }) {
    //* 1. PERSISTENT CONTEXT: Reference for the dialog to ensure reliable dismissal
    BuildContext? dialogContext;

    //* 2. UI OVERLAY: Show a high-fidelity loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.primaryDarker.withValues(alpha: 0.9),
      builder: (loadingCtx) {
        dialogContext = loadingCtx; // Capture the specific dialog context
        return Center(
          child: Lottie.asset(AppLottie.edit, width: 180, height: 180),
        );
      },
    );

    //* 3. DATA ACQUISITION: Trigger the Cubit to fetch missing material items
    final cubit = context.read<MaterialFetchCubit>();
    cubit.fetchMaterialDetails(materialId: material.id);

    //* 4. STATE OBSERVER: React to the API response through the Bloc stream
    cubit.stream
        .firstWhere(
          (state) =>
              state is MaterialFetchDetailsSuccess ||
              state is MaterialDetailsFetchFailure,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => MaterialDetailsFetchFailure('Connection Timeout'),
        )
        .then((state) {
          //* 5. CLEANUP: Safely dismiss the loading overlay using its own context
          if (dialogContext != null && dialogContext!.mounted) {
            Navigator.of(dialogContext!).pop();
          }

          //* 6. FINALIZATION: Ensure the parent view is still active before navigating
          if (context.mounted) {
            if (state is MaterialFetchDetailsSuccess) {
              MaterialsNavigationHandler.navigateToEditMaterial(
                context,
                courseId: courseId,
                material: state.material,
              );
            } else {
              AppSnackBar.error(
                context,
                'Data synchronization failed. Please try again.',
              );
            }
          }
        });
  }

  /// Helper to maintain consistent row styling for menu items.
  static PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  /// Centralized card tap handling.
  static void handleCardTap(
    BuildContext context,
    MaterialModel material,
    String courseId,
  ) {
    MaterialsNavigationHandler.navigateToDetails(
      context,
      courseId: courseId,
      material: material,
    );
  }
}
