import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';

/// A shared wrapper that handles CRUD state logic for both Mobile and Web.
/// This prevents code duplication and ensures consistent UI feedback (SnackBars/Pops).
class MaterialCrudListener extends StatelessWidget {
  final Widget child;

  const MaterialCrudListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialCrudCubit, MaterialCrudState>(
      listener: (context, state) {
        //? Logic: Centralized handling for any state that returns an updated MaterialModel.
        if (state is DeleteMaterialItemSuccess ||
            state is AddMaterialItemsSuccess ||
            state is UpdateMaterialSuccess) {
          final material = (state as dynamic)
              .material; // Access material from success states

          context.read<MaterialFetchCubit>().updateMaterialDetails(material);

          if (Navigator.canPop(context)) Navigator.pop(context);

          AppSnackBar.success(
            context,
            state is DeleteMaterialItemSuccess
                ? 'Item Deleted and Updated Successfully!'
                : 'Material Updated Successfully!',
          );
        } else if (state is DeleteMaterialItemFailure ||
            state is AddMaterialItemsFailure ||
            state is UpdateMaterialFailure) {
          final message = (state as dynamic).errMessage;
          if (Navigator.canPop(context)) Navigator.pop(context);
          AppSnackBar.error(context, message ?? 'Failed to Update Material');
        }
      },
      child: child,
    );
  }
}
