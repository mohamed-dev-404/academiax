import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/delete_single_item_dialog.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/file_preview_screen.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/material_item_card.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/video_player_screen.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (materials.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Lottie.asset(
                  AppLottie.empty,
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text('No files attached to this material.'),
              ],
            ),
          ),
        ),
      );
    }

    final videoItems = materials.where((item) => item.isVideoItem).toList();
    final documentItems = materials.where((item) => !item.isVideoItem).toList();

    return SliverMainAxisGroup(
      slivers: [
        if (videoItems.isNotEmpty) ...[
          _buildHeader('Videos'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildCard(videoItems[index], context),
              childCount: videoItems.length,
            ),
          ),
        ],
        if (documentItems.isNotEmpty) ...[
          if (videoItems.isNotEmpty)
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildHeader('Documents'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildCard(documentItems[index], context),
              childCount: documentItems.length,
            ),
          ),
        ],
      ],
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
    return MaterialItemCard(
      fileName: file.originalFileName ?? 'Unknown File',
      description: '',
      icon: file.icon,
      iconColor: file.color,
      materialType: file.isVideoItem
          ? CourseMaterialType.video
          : CourseMaterialType.pdf,
      onTap: () => _handleItemTap(context, file),
      onDelete: () => _confirmAndDelete(context, file), // Added delete callback
    );
  }

  void _confirmAndDelete(BuildContext context, MaterialItemModel item) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<MaterialCrudCubit>(),
        child: DeleteSingleItemDialog(
          materialId: materialId,
          itemKey: item.key ?? '',
          fileName: item.originalFileName ?? 'Unknown File',
        ),
      ),
    );
  }

  void _handleItemTap(BuildContext context, MaterialItemModel file) async {
    final url = file.displayUrl ?? '';
    if (url.isEmpty) return;

    if (kIsWeb) {
      await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
    } else {
      if (file.isVideoItem) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoUrl: url,
              videoTitle: file.originalFileName ?? 'Video',
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilePreviewScreen(
              url: url,
              fileName: file.originalFileName ?? 'File',
            ),
          ),
        );
      }
    }
  }
}
