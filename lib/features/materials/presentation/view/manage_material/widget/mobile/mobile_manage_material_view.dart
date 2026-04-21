import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/mobile/mobile_manage_material_view_body.dart';

/// The mobile entry-point for the Material Management feature.
/// It wraps the [MobileManageMaterialViewBody] with a mobile-specific [Scaffold]
/// and a pre-configured [AppBar].
class MobileManageMaterialView extends StatelessWidget {
  const MobileManageMaterialView({
    super.key,
    required this.isEditMode,
    required this.courseId,
  });

  /// Indicates whether the view is used for updating existing material or creating new ones.
  final bool isEditMode;

  /// The unique ID used to associate the material with a specific course.
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //? Dynamic title assignment based on the current mode (Edit vs Add).
      appBar: MobileCustomAppBar(
        title: isEditMode ? 'Edit Material' : 'Add Material',
      ),
      //* Passes parameters down to the body which handles the actual form logic.
      body: MobileManageMaterialViewBody(
        isEditMode: isEditMode,
        courseId: courseId,
      ),
    );
  }
}
