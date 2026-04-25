import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/assignments/data/model/assignment_item_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/add_assignment_items_dialog.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/file_preview_screen.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/instructor/delete_single_item_dialog.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignmentDetailsHandler {
  static void openMaterialItem(BuildContext context, AssignmentItemModel item) {
    final String url = item.displayUrl ?? '';
    if (url.isEmpty) return;

    if (kIsWeb) {
      //? Web-specific: Open URLs in a new browser tab.
      launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
    } else {
      //* Mobile-specific: Route to internal preview screens.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilePreviewScreen(
            url: url,
            fileName: item.originalFileName ?? 'File',
          ),
        ),
      );
    }
  }

  static void onDeleteItem(
    BuildContext context, {
    required String assignmentId,
    required AssignmentItemModel item,
  }) {
    final cubit = context.read<AssignmentDetailsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: DeleteAssignmentItemDialog(
          assignmentId: assignmentId,
          item: item,
          onDelete: () =>
              cubit.deleteSingleItem(assignmentId: assignmentId, itemKey: item.key!),
        ),
      ),
    );
  }

  static void onAddItemsCard(
    BuildContext context, {
    required String assignmentId,
  required String courseId,
  required String classworkId
  }) {
    final cubit = context.read<AssignmentDetailsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: AddNewAssignmentItemsDialog(
          assignmentId: assignmentId,
          courseId: courseId, classworkId: classworkId,
        ),
      ),
    );
  }
}
