import 'package:flutter/material.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/web/web_manage_material_view_body.dart';

/// A entry-point widget for the Web Material Management screen.
/// This widget provides the [Scaffold] structure and delegates the actual
/// UI construction to [WebManageMaterialViewBody].
class WebManageMaterialView extends StatelessWidget {
  const WebManageMaterialView({
    super.key,
    required this.isEditMode,
    required this.courseId,
  });

  /// Determines if the form should behave as an 'Update' (true) or 'Create' (false) operation.
  final bool isEditMode;

  /// The unique identifier of the course to which the material belongs.
  final String courseId;

  @override
  Widget build(BuildContext context) {
    //? We use a Scaffold here to provide a base for overlays, snackbars, and theme support.
    return Scaffold(
      //* Delegation to the specific Web Body widget for better separation of concerns.
      body: WebManageMaterialViewBody(
        isEditMode: isEditMode,
        courseId: courseId,
      ),
    );
  }
}
