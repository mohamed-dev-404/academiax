import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';

/// A standardized Floating Action Button used to trigger the "Add Materials" flow.
/// This widget is shared across Mobile and Web layouts to maintain visual consistency.
class AddMaterialItemsFloatingBuutton extends StatelessWidget {
  const AddMaterialItemsFloatingBuutton({
    super.key,
    required this.courseId,
    required this.materialId,
  });

  final String courseId;
  final String materialId;

  @override
  Widget build(BuildContext context) {
    return (CurrentRole.role == UserRole.instructor)
        ? FloatingActionButton(
            //* Branding: Uses the primary theme color for high visibility.
            backgroundColor: AppColors.primary,

            //* Logic Delegation: Triggers the dialog via the centralized Navigation Handler.
            onPressed: () =>
                MaterialsNavigationHandler.showAddMaterialItemsDialog(
                  context,
                  courseId: courseId,
                  materialId: materialId,
                ),

            //* Iconography: Uses a custom SVG icon with a white color filter for contrast.
            child: SvgPicture.asset(
              AppIcons.iconsPlusFloatingButton,
              colorFilter: const ColorFilter.mode(
                AppColors.whiteLight,
                BlendMode.srcIn,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
