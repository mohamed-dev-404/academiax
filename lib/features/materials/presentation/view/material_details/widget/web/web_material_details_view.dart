import 'package:flutter/material.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/add_material_items_floating_buttom.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/web/web_material_details_view_body.dart';

/// The top-level scaffold for the Material Details interface on Web/Desktop.
/// It acts as a wrapper that hosts the main body and the creation action button.
class WebMaterialDetailsView extends StatelessWidget {
  final String courseId;
  final String materialId;

  const WebMaterialDetailsView({super.key, required this.courseId, required this.materialId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* Floating Action Button: Positioned for quick access to add new course items.
      //* It receives the [courseId] to ensure new uploads are linked to the correct course.
      floatingActionButton: AddMaterialItemsFloatingBuutton(courseId: courseId, materialId: materialId,),

      //* Main Content: Delegated to the Web-specific body widget which handles
      //* the dual-pane layout and state management.
      body:  WebMaterialDetailsViewBody(courseId: courseId, materialId: materialId,),
    );
  }
}
