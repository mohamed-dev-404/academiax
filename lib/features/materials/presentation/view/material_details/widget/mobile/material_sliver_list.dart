import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/logic/material_details_handler.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/empty_items.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/material_item_card.dart';

/// A sliver-based list that categorizes and displays course materials into
/// Videos and Documents sections.
class MaterialsSliverList extends StatelessWidget {
  final List<MaterialItemModel> materials;
  final String materialId;

  const MaterialsSliverList({
    super.key,
    required this.materials,
    required this.materialId,
  });

  @override
  Widget build(BuildContext context) {
    //* Handle the empty state within the sliver protocol.
    if (materials.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: EmptyItems(),
          ),
        ),
      );
    }

    //? Split data using centralized handler logic.
    final categorized = MaterialDetailsHandler.getCategorizedMaterials(
      materials,
    );
    final videoItems = categorized['videos']!;
    final documentItems = categorized['files']!;

    //* Using SliverMainAxisGroup to treat multiple slivers as a single logical unit.
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 50),
      sliver: SliverMainAxisGroup(
        slivers: [
          //* Video Section
          if (videoItems.isNotEmpty) ...[
            _buildHeader('Videos'),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCard(videoItems[index], context),
                childCount: videoItems.length,
              ),
            ),
          ],

          //* Document Section
          if (documentItems.isNotEmpty) ...[
            if (videoItems.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _buildHeader('Files & Documents'),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCard(documentItems[index], context),
                childCount: documentItems.length,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(MaterialItemModel file, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: MaterialItemCard(
        fileName: file.originalFileName ?? 'Unknown File',
        description: '',
        icon: file.icon,
        iconColor: file.color,
        materialType: file.isVideoItem
            ? CourseMaterialType.video
            : CourseMaterialType.pdf,
        onTap: () => MaterialDetailsHandler.onItemTap(context, file),
        onDelete: () => MaterialDetailsHandler.onDeleteItem(
          context,
          materialId: materialId,
          item: file,
        ),
      ),
    );
  }
}
