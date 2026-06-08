import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/mobile_material_details_view_body.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/add_material_items_floating_buttom.dart';

/// The mobile-specific scaffold for displaying detailed material content.
/// It integrates the custom app bar, the main scrollable body, and the creation trigger.
class MobileMaterialDetailsView extends StatelessWidget {
  const MobileMaterialDetailsView({
    super.key,
    required this.courseId,
    required this.materialId,
  });

  final String courseId;
  final String materialId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* Standardized Mobile AppBar with the feature title.
      appBar: const MobileCustomAppBar(title: 'Material Details'),

      //* Floating Action Button (FAB) dedicated to adding new items (Videos/Docs) to the course.
      floatingActionButton: AddMaterialItemsFloatingBuutton(
        courseId: courseId,
        materialId: materialId,
      ),

      //* The main content area, handled by a separate Body widget for better state management.
      body: const MobileMaterialDetailsViewBody(),
    );
  }
}
