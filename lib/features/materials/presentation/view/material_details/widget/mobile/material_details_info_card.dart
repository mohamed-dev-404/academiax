import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/logic/material_details_handler.dart';

/// [MaterialDetailsInfoCard]
/// A high-level informational component that displays core metadata for a specific course material.
/// This widget adapts its interactive capabilities based on the authenticated user's administrative privileges.
class MaterialDetailsInfoCard extends StatelessWidget {
  /// The data source containing material titles, descriptions, and identity keys.
  final MaterialModel material;

  const MaterialDetailsInfoCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Container(
      //* Layout: Defined fixed margins for consistent spacing within the Material Details view.
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 22,
      ),
      //* Visual Styling: Utilizing [AppColors.primaryLight] to distinguish header info from the items list.
      padding: const EdgeInsets.symmetric(
        horizontal: 21,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Header Logic: Title is expanded to prevent overflow when instructor controls are visible.
              Expanded(
                child: Text(
                  material.title,
                  style: AppStyles.mobileTitleLargeMd.copyWith(
                    color: AppColors.primaryDarkHover,
                  ),
                ),
              ),

              //? Permission Guard: [UserRole.instructor] check ensures only authorized users see the edit trigger.
              if (CurrentRole.role == UserRole.instructor)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    //_ Action: Delegates sheet/dialog triggering to the MaterialDetailsHandler.
                    onPressed: () =>
                        MaterialDetailsHandler.onEditMaterialMobile(
                          context,
                          material,
                        ),
                    icon: SvgPicture.asset(
                      AppIcons.iconsEditMaterial,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          //* Content Section: Displays the primary summary provided by the instructor.
          Text(
            material.description,
            style: AppStyles.mobileBodyMediumRg.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
