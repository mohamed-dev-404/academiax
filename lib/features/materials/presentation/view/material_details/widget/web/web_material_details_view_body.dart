import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/shared/tab_body_view.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_header.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/material_crud_listener.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/web/material_content_grid.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/web/material_details_side_card.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// The Web-specific implementation of the Material Details body.
/// It uses a dual-pane layout: a fixed-width sidebar for metadata and a flexible grid for content.
class WebMaterialDetailsViewBody extends StatelessWidget {
  final String courseId;
  final String materialId;
  const WebMaterialDetailsViewBody({
    super.key,
    required this.courseId,
    required this.materialId,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCrudListener(
      child: BlocBuilder<MaterialFetchCubit, MaterialFetchState>(
        //_ Optimization: Rebuild only for relevant Material Details states.
        buildWhen: (previous, current) => current is MaterialDetailsState,
        builder: (context, state) {
          if (state is MaterialFetchLoading) {
            return const Center(child: AppAnimatedLoadingIndicator());
          }

          if (state is MaterialFetchFailure) {
            return Center(child: Text(state.errMessage));
          }

          if (state is MaterialFetchDetailsSuccess) {
            final material = state.material;

            return Column(
              children: [
                //* Shared Web Header (Breadcrumbs, Search, Profile).
                const WebHomeHeader(),

                Expanded(
                  child: TabBodyView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        //? Ensures both panes align perfectly at the top and bottom.
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //* 1. Metadata Pane: Sidebar info (Title, Description, Edit Button).
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 230,
                              maxWidth:
                                  (MediaQuery.sizeOf(context).width * 0.28)
                                      .clamp(230, 450),
                            ),
                            child: MaterialDetailsSideCard(
                              courseId: courseId,
                            ),
                          ),

                          const SizedBox(
                            width: 32,
                          ), // Layout spacing for Web aesthetics.
                          //* 2. Content Pane: Scrollable grid of files and videos.
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 20,
                                  ),
                                  child: Text(
                                    'Material Content',
                                    style: AppStyles.webTitleMediumSb.copyWith(
                                      color: AppColors.primaryDarkHover,
                                      fontSize:
                                          (MediaQuery.sizeOf(context).width *
                                                  0.022)
                                              .clamp(24, 32),
                                    ),
                                  ),
                                ),
                                //_ Flexible grid that fills the remaining space.
                                Expanded(
                                  child: MaterialContentGrid(
                                    materials: material.materialItems,
                                    materialId: material.id,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
