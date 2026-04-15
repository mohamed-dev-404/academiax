import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/mobile_material_details_view_body.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/add_material_items_dialog.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';

class MobileMaterialDetailsView extends StatelessWidget {
  const MobileMaterialDetailsView({super.key, required this.courseId});
  final String courseId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileCustomAppBar(title: 'Material Details'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddMaterialItemsDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: const MobileMaterialDetailsViewBody(),
    );
  }
  void _showAddMaterialItemsDialog(BuildContext context) {
    final String materialId =
        GoRouterState.of(context).pathParameters['materialId'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<MaterialCrudCubit>()),
          BlocProvider.value(value: context.read<MaterialFetchCubit>()),
        ],
        child: AddNewMaterialItemsDialog(
          courseId: courseId,
          materialId: materialId,
        ),
      ),
    );
  }
}
