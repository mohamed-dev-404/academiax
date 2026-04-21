import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/logic/material_details_handler.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/empty_items.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/material_item_card.dart';

/// A grid-based layout for Web/Desktop that displays course materials.
/// It categorizes items into "Videos" and "Files" and arranges them in a responsive grid.
class MaterialContentGrid extends StatelessWidget {
  final List<MaterialItemModel> materials;
  final String materialId;

  const MaterialContentGrid({
    super.key,
    required this.materials,
    required this.materialId,
  });

  @override
  Widget build(BuildContext context) {
    //* Handle state where no materials are available.
    if (materials.isEmpty) {
      return const Center(
        child: EmptyItems(),
      );
    }

    //? Data Segregation: Splitting materials based on their media type via Handler.
    final categorized = MaterialDetailsHandler.getCategorizedMaterials(
      materials,
    );
    final videoItems = categorized['videos']!;
    final fileItems = categorized['files']!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: [
        //* Rendering Video Section if items exist.
        if (videoItems.isNotEmpty) ...[
          _buildSectionTitle('Videos'),
          _buildGrid(context, videoItems),
          const SizedBox(height: 24),
        ],

        //* Rendering Files Section if items exist.
        if (fileItems.isNotEmpty) ...[
          _buildSectionTitle('Files & Documents'),
          _buildGrid(context, fileItems),
        ],
      ],
    );
  }

  /// Builds a section header styled for the Web interface.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title,
        style: AppStyles.web24Semibold.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// Creates a responsive grid using [GridView.builder].
  /// Uses [SliverGridDelegateWithMaxCrossAxisExtent] to handle multi-column layouts automatically.
  Widget _buildGrid(BuildContext context, List<MaterialItemModel> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), //? The parent ListView handles scrolling.
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MaterialItemCard(
          fileName: item.originalFileName ?? 'Unknown',
          description: '',
          icon: item.icon,
          iconColor: item.color,
          materialType: item.isVideoItem
              ? CourseMaterialType.video
              : CourseMaterialType.pdf,
          onTap: () => MaterialDetailsHandler.onItemTap(context, item),
          onDelete: () => MaterialDetailsHandler.onDeleteItem(
            context,
            materialId: materialId,
            item: item,
          ),
        );
      },
    );
  }
}
