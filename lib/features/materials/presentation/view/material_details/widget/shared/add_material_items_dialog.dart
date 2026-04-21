import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/course_material_section.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/uploading_overlay.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// A specialized dialog for adding new files/videos to an existing material topic.
/// It coordinates the upload process and subsequent data refresh to ensure UI consistency.
class AddNewMaterialItemsDialog extends StatefulWidget {
  final String courseId;
  final String materialId;

  const AddNewMaterialItemsDialog({
    super.key,
    required this.courseId,
    required this.materialId,
  });

  @override
  State<AddNewMaterialItemsDialog> createState() =>
      _AddNewMaterialItemsDialogState();
}

class _AddNewMaterialItemsDialogState extends State<AddNewMaterialItemsDialog> {
  //* Accessing the internal state of the material section to retrieve picked files.
  final GlobalKey<CourseMaterialSectionState> _sectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);

    return Stack(
      children: [
        AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Add New Materials',
                style: isMobile
                    ? AppStyles.mobileTitleSmallSb
                    : AppStyles.mobileTitleMediumSb,
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: CourseMaterialSection(
                key: _sectionKey,
                initialItems:
                    const [], // Starting with an empty selection for new items.
              ),
            ),
          ),
          actions: [
            //* Reactive Actions: Hide buttons during loading to prevent duplicate requests.
            BlocBuilder<MaterialCrudCubit, MaterialCrudState>(
              builder: (context, crudState) {
                final bool isLoading = crudState is AddMaterialItemsLoading;

                if (isLoading) return const SizedBox.shrink();

                return Row(
                  children: [
                    Expanded(
                      child: CustomAppButton(
                        label: 'Cancel',
                        height: 40,
                        textColor: AppColors.primaryDark,
                        backgroundColor: AppColors.secondaryLight,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomAppButton(
                        label: 'Confirm',
                        height: 40,
                        textColor: AppColors.whiteLight,
                        backgroundColor: AppColors.primary,
                        onPressed: _handleConfirm,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),

        //* Blocking UI: Shows the uploading overlay during both transmission and post-upload fetching.
        BlocBuilder<MaterialFetchCubit, MaterialFetchState>(
          builder: (context, state) {
            return BlocBuilder<MaterialCrudCubit, MaterialCrudState>(
              builder: (context, crudState) {
                if (crudState is AddMaterialItemsLoading ||
                    state is MaterialFetchLoading) {
                  return const UploadingOverlay();
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ],
    );
  }

  /// Handles the confirmation of adding new files to the material topic.
  void _handleConfirm() {
    //? Extracting the picked files via the GlobalKey before triggering the Cubit.
    final allFiles = _sectionKey.currentState?.allPickedFiles ?? [];

    if (allFiles.isNotEmpty) {
      context.read<MaterialCrudCubit>().addNewItemsOnly(
        materialId: widget.materialId,
        courseId: widget.courseId,
        newFiles: allFiles,
      );
    } else {
      AppToast.warning(
        context,
        'Please select at least one file.',
      );
    }
  }
}
