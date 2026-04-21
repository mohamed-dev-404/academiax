import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/widget/mobile/materials_mobile_layout.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/widget/web/materials_web_layout.dart';

/// The root entry point for the Materials Tab.
/// It orchestrates state management and adaptive rendering for both Mobile and Web platforms.
class MaterialsTabView extends StatelessWidget {
  final String courseId;
  const MaterialsTabView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return
    //* Adaptive UI Layer:
    //* Seamlessly switches between Mobile and Web layouts based on screen constraints.
    AdaptiveLayout(
      mobileLayout: (context) => MaterialsMobileLayout(
        courseId: courseId,
      ),
      webLayout: (context) => MaterialsWebLayout(
        courseId: courseId,
      ),
    );
  }
}
