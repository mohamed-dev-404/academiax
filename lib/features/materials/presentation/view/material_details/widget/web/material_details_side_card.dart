import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// A responsive side information card for the Web interface.
/// It displays material metadata (Title, Illustration, Description) and
/// provides edit access for instructors.
class MaterialDetailsSideCard extends StatelessWidget {
  const MaterialDetailsSideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaterialFetchCubit, MaterialFetchState>(
      builder: (context, state) {
        //* Safety Check: Only render the card if the material data is successfully fetched.
        if (state is! MaterialFetchDetailsSuccess) {
          return const SizedBox.shrink();
        }

        final material = state.material;

        //* LayoutBuilder is used here to create a fluid UI that scales based on the sidebar width.
        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Visual Identity: The top illustration scales proportionally.
                    Center(
                      child: SvgPicture.asset(
                        AppImages.imagesWebMaterialDetailsSider,
                        width: width * 0.6,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    //* Header Row: Title and the conditional Edit Action.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            material.title,
                            //? Clamp ensures the font size stays within readable bounds on different screen sizes.
                            style: AppStyles.webTitleMediumSb.copyWith(
                              color: AppColors.primaryDarkHover,
                              fontSize: (width * 0.09).clamp(20, 28),
                            ),
                          ),
                        ),

                        //* Role Guard: Management actions are restricted to instructors.
                        if (CurrentRole.role == UserRole.instructor)
                          IconButton(
                            onPressed: () => _onEditPressed(context, material),
                            icon: SvgPicture.asset(
                              AppIcons.iconsEditMaterial,
                              width: 24,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    //* Informational Body: Displays the long-form description of the material.
                    Text(
                      material.description,
                      style: AppStyles.mobileBodyLargeRg.copyWith(
                        color: AppColors.primary,
                        fontSize: (width * 0.06).clamp(14, 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Extracts navigation context and opens the editing interface.
  void _onEditPressed(BuildContext context, MaterialModel material) async {
    final courseId = GoRouterState.of(context).pathParameters['courseId'] ?? '';

    //* Delegation: Navigation logic is kept outside the UI widget.
    MaterialsNavigationHandler.navigateToEditMaterial(
      context,
      courseId: courseId,
      material: material,
    );
  }
}
