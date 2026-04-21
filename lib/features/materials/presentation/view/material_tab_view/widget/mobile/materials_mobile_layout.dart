import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/mobile/mobile_main_card.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/features/materials/presentation/logic/material_navigation_handler.dart';
import 'package:sams_app/features/materials/presentation/logic/material_refresh_trigger.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/empty_items.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/logic/material_tap_handler.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// Mobile-optimized layout for course materials using a scrollable list.
/// Displays a list of materials fetched from the server.
/// Provides the option to add a new material.
class MaterialsMobileLayout extends StatefulWidget {
  const MaterialsMobileLayout({super.key, required this.courseId});
  final String courseId;

  @override
  State<MaterialsMobileLayout> createState() => _MaterialsMobileLayoutState();
}

class _MaterialsMobileLayoutState extends State<MaterialsMobileLayout> {
  @override
  void initState() {
    super.initState();
    //* Listen for data refresh requests from shared logic.
    MaterialRefreshTrigger.shouldRefresh.addListener(_fetch);
  }

  @override
  void dispose() {
    MaterialRefreshTrigger.shouldRefresh.removeListener(_fetch);
    super.dispose();
  }

  /// Refetches material data from the server.
  void _fetch() {
    if (mounted) {
      context.read<MaterialFetchCubit>().fetchMaterials(
        courseId: widget.courseId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isInstructor = CurrentRole.role == UserRole.instructor;

    return BlocBuilder<MaterialFetchCubit, MaterialFetchState>(
      //? Rebuild guard: ignore UI states that don't affect the data list.
      buildWhen: (previous, current) =>
          current is MaterialFetchSuccess ||
          current is MaterialFetchLoading ||
          current is MaterialFetchFailure,
      builder: (context, state) {
        return RefreshIndicator(
          //* Enable swipe-to-refresh for mobile users.
          onRefresh: () async => _fetch(),
          child: CustomScrollView(
            //? physics: forced to allow scrolling even if list is short (for RefreshIndicator).
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              //* 1. Instructor "Add" Action (Top-level card)
              if (isInstructor)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  sliver: SliverToBoxAdapter(
                    child: AddNewCard(
                      isMobile: true,
                      title: 'Add Material',
                      onTap: () =>
                          MaterialsNavigationHandler.navigateToManageMaterial(
                            context,
                            courseId: widget.courseId,
                          ),
                    ),
                  ),
                ),

              //* 2. Dynamic State Rendering based on Cubit state.
              if (state is MaterialFetchLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: AppAnimatedLoadingIndicator()),
                ),

              if (state is MaterialFetchFailure)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(state.errMessage)),
                ),

              if (state is MaterialFetchSuccess)
                   SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final material = state.materials[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Builder(
                            builder: (cardContext) => MobileMainCard(
                              cardModel: MainCardModel(
                                title: material.title,
                                description: material.description,
                                image: AppImages.imagesMaterialCard,
                                actionWidget: isInstructor
                                    ? SvgPicture.asset(
                                        AppIcons.iconsMenu,
                                        width: 22,
                                        height: 22,
                                      )
                                    : null,
                                onActionTap: () {
                                  //! Distinct logic for Instructor menu vs Student navigation.
                                  if (isInstructor) {
                                    MaterialTabHandler.showMaterialActionsMenu(
                                      context: context,
                                      anchorContext: cardContext,
                                      material: material,
                                      courseId: widget.courseId,
                                    );
                                  } else {
                                    MaterialTabHandler.handleCardTap(
                                      context,
                                      material,
                                      widget.courseId,
                                    );
                                  }
                                },
                                onTap: () => MaterialTabHandler.handleCardTap(
                                  context,
                                  material,
                                  widget.courseId,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.materials.length,
                    ),
                  ),
                if (state is MaterialFetchSuccess && state.materials.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: EmptyItems(),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
