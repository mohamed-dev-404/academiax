import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/material_details_info_card.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/material_sliver_list.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/material_crud_listener.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_state.dart';

/// The primary body widget for material details on mobile devices.
/// It coordinates state synchronization between [MaterialCrudCubit] and [MaterialFetchCubit]
/// to ensure the UI remains updated after deletions or edits.
class MobileMaterialDetailsViewBody extends StatelessWidget {
  const MobileMaterialDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialCrudListener(
      child: BlocBuilder<MaterialFetchCubit, MaterialFetchState>(
        //_ Optimized rebuilds: Only listen to states relevant to the details view.
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

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                //* Material Info Header Section
                SliverToBoxAdapter(
                  child: MaterialDetailsInfoCard(material: material),
                ),

                //* Section Divider Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      'Material Content',
                      style: AppStyles.mobileTitleMediumSb.copyWith(
                        color: AppColors.primaryDarkHover,
                      ),
                    ),
                  ),
                ),

                //* Specialized sliver for rendering the list of files (Videos/Docs).
                MaterialsSliverList(
                  materials: material.materialItems,
                  materialId: material.id,
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
