import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/core/widgets/shared/app_grid_style.dart';
import 'package:sams_app/core/widgets/shared/tab_body_view.dart';
import 'package:sams_app/core/widgets/web/web_main_card.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';
import 'package:sams_app/features/materials/presentation/logic/material_refresh_trigger.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/empty_items.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/logic/material_tap_handler.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// Web-specific layout for displaying course materials in a responsive grid.
/// It includes a fixed-width sidebar for metadata and a flexible grid for content.
/// It also provides the ability to add new materials.
class MaterialsWebLayout extends StatefulWidget {
  const MaterialsWebLayout({super.key, required this.courseId});
  final String courseId;

  @override
  State<MaterialsWebLayout> createState() => _MaterialsWebLayoutState();
}

class _MaterialsWebLayoutState extends State<MaterialsWebLayout> {
  @override
  void initState() {
    super.initState();
    //* Register listener for external refresh triggers.
    MaterialRefreshTrigger.shouldRefresh.addListener(_fetch);
  }

  @override
  void dispose() {
    //* Cleanup listener to prevent memory leaks.
    MaterialRefreshTrigger.shouldRefresh.removeListener(_fetch);
    super.dispose();
  }

  /// Dispatches fetch event to MaterialFetchCubit.
  void _fetch() {
    //? Ensure widget is active before updating state.
    if (mounted) {
      context.read<MaterialFetchCubit>().fetchMaterials(
        courseId: widget.courseId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //* Identify user privileges and screen constraints.
    final bool isInstructor = CurrentRole.role == UserRole.instructor;
    final bool isMobile = SizeConfig.isMobile(context);

    return TabBodyView(
      child: BlocBuilder<MaterialFetchCubit, MaterialFetchState>(
        //? Optimized rebuilds: only trigger on core data state changes.
        buildWhen: (previous, current) =>
            current is MaterialFetchSuccess ||
            current is MaterialFetchLoading ||
            current is MaterialFetchFailure,
        builder: (context, state) {
          if (state is MaterialFetchLoading) {
            return const Center(child: AppAnimatedLoadingIndicator());
          }
          if (state is MaterialFetchFailure) {
            return Center(child: Text(state.errMessage));
          }

          if (state is MaterialFetchSuccess) {
            final materials = state.materials;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    //? Dynamic Grid layout optimized for Web/Tablet
                    (context, index) {
                      //* Role-based UI: Inject "Add" card at the end of the list for Instructors.
                      if (isInstructor && index == 0) {
                        return AddNewCard(
                          isMobile: isMobile,
                          title: 'Add Material',
                          onTap: () =>
                              MaterialsNavigationHandler.navigateToManageMaterial(
                                context,
                                courseId: widget.courseId,
                              ),
                        );
                      }

                      final material =
                          materials[index - (isInstructor ? 1 : 0)];
                      //* Individual Material Card logic.
                      return Builder(
                        builder: (cardContext) => WebMainCard(
                          model: MainCardModel(
                            title: material.title,
                            description: material.description,
                            image: AppImages.imagesMaterialCard,
                            //_ Conditional action widget for management menu.
                            actionWidget: isInstructor
                                ? SvgPicture.asset(
                                    AppIcons.iconsMenu,
                                    width: 22,
                                    height: 22,
                                  )
                                : null,
                            onActionTap: isInstructor
                                ? () =>
                                      MaterialTabHandler.showMaterialActionsMenu(
                                        context: context,
                                        anchorContext: cardContext,
                                        material: material,
                                        courseId: widget.courseId,
                                      )
                                : null,
                            onTap: () => MaterialTabHandler.handleCardTap(
                              context,
                              material,
                              widget.courseId,
                            ),
                          ),
                        ),
                      );
                    },
                    //? List length + 1 for the instructor's action card.
                    childCount: materials.length + (isInstructor ? 1 : 0),
                  ),
                  gridDelegate: AppGridStyles.tapGridDelegate,
                ),
                if (materials.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: EmptyItems(),
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
