import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/mobile/mobile_manage_material_view.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/web/web_manage_material_view.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';

/// The entry point for the Material Management feature.
/// It uses [AdaptiveLayout] to switch between Mobile and Web views seamlessly.
class ManageMaterialView extends StatelessWidget {
  const ManageMaterialView({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MaterialCrudCubit>();

    //* Logic: Determine if we are in "Edit Mode" based on the presence of initial data in the Cubit.
    //? This centralizes the mode detection instead of passing flags through multiple routes.
    final bool isEditMode = cubit.initialMaterial != null;

    return AdaptiveLayout(
      //* Mobile View Configuration
      mobileLayout: (context) => MobileManageMaterialView(
        isEditMode: isEditMode,
        courseId: courseId,
      ),

      //* Web/Desktop View Configuration
      webLayout: (context) => WebManageMaterialView(
        isEditMode: isEditMode,
        courseId: courseId,
      ),
    );
  }
}
