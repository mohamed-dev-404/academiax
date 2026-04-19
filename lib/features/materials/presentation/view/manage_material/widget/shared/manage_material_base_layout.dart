import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/update_progress_overlay.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/uploading_overlay.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

/// A shared base layout that handles the common BlocConsumer logic,
/// loading overlays, and interaction blocking for both Web and Mobile.
class ManageMaterialBaseLayout extends StatelessWidget {
  final Widget child;

  const ManageMaterialBaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaterialCrudCubit, MaterialCrudState>(
      listenWhen: (previous, current) =>
          current is UpdateMaterialSuccess ||
          current is CreateMaterialSuccess ||
          current is CreateMaterialFailure ||
          current is UpdateMaterialFailure,
      listener: (context, state) {
        if (state is UpdateMaterialSuccess) {
          AppSnackBar.success(context, state.message);
          //* Return the updated material object to the previous screen.
          context.pop(state.material);
        } else if (state is CreateMaterialSuccess) {
          //* Return the newly created model so the parent list can update locally.
          AppSnackBar.success(context, state.message);
          context.pop(state.material);
        } else if (state is CreateMaterialFailure ||
            state is UpdateMaterialFailure) {
          //! Explicitly cast to dynamic to access errMessage safely if types differ.
          AppSnackBar.error(context, (state as dynamic).errMessage);
        }
      },
      builder: (context, state) {
        //* Decouple various loading states to manage UI blocking and overlays.
        final isCreateLoading = state is CreateMaterialLoading;
        final isCreateUploading = isCreateLoading && state.isUploadingFiles;
        final isUpdateLoading = state is UpdateMaterialLoading;

        //? Extract dynamic message for the update overlay if applicable.
        String updateMsg = (state is UpdateMaterialLoading)
            ? state.message
            : '';

        return Stack(
          children: [
            //* Interactive UI Layer.
            //! Disable all clicks and dim the screen during active uploads/updates.
            IgnorePointer(
              ignoring: isCreateUploading || isUpdateLoading,
              child: Opacity(
                opacity: (isCreateUploading || isUpdateLoading) ? 0.3 : 1.0,
                child: child,
              ),
            ),

            //* Feedback Overlays: Appear globally within the Stack during processing.
            if (isCreateUploading) const UploadingOverlay(),
            if (isUpdateLoading) UpdateProgressOverlay(message: updateMsg, operationType: state.operationType,),
          ],
        );
      },
    );
  }
}
