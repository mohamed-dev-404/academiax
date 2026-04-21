import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

/// A shared widget that observes the MaterialCrudCubit state.
/// It renders the action button only when no asynchronous operations are active.
class ManageMaterialSubmitButton extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onPressed;

  const ManageMaterialSubmitButton({
    super.key,
    required this.isEditMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaterialCrudCubit, MaterialCrudState>(
      buildWhen: (previous, current) =>
          current is CreateMaterialLoading ||
          current is UpdateMaterialLoading ||
          current is MaterialCrudInitial || // To handle reset states if needed
          current is CreateMaterialFailure ||
          current is UpdateMaterialFailure,
      builder: (context, state) {
        //* Prevent submission if any asynchronous operation is in progress.
        final anyLoading =
            state is CreateMaterialLoading || state is UpdateMaterialLoading;

        if (anyLoading) return const SizedBox.shrink();

        return CustomAppButton(
          width: 220,
          height: 50,
          borderRadius: 16,
          label: isEditMode ? 'Edit Material' : 'Add Material',
          //* Triggers the validation and submission logic defined in the handler/mixin.
          onPressed: onPressed,
        );
      },
    );
  }
}
