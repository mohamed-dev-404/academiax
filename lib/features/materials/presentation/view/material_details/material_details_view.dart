import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/mobile/mobile_material_details_view.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/web/web_material_details_view.dart';

/// A wrapper widget that manages the Material Details screen across different platforms.
/// It extracts routing parameters and delegates the UI to platform-specific layouts.
class MaterialDetailsView extends StatelessWidget {
  const MaterialDetailsView({
    super.key,
    required this.materialId,
    required this.courseId,
  });
  final String materialId;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      //* Mobile/Tablet Layout: Displays a scrollable sliver-based view.
      mobileLayout: (context) => MobileMaterialDetailsView(
        courseId: courseId,
        materialId: materialId,
      ),

      //* Web/Desktop Layout: Displays a dual-pane dashboard-style view.
      webLayout: (context) => WebMaterialDetailsView(
        courseId: courseId,
        materialId: materialId,
      ),
    );
  }
}
