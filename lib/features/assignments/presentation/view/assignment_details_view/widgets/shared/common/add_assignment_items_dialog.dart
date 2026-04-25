import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/course_assignment_section.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/uploading_overlay.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_state.dart';

/// A specialized dialog for adding new files to an existing assignment.
class AddNewAssignmentItemsDialog extends StatefulWidget {
  final String courseId;
  final String assignmentId;
  final String classworkId;

  const AddNewAssignmentItemsDialog({
    super.key,
    required this.courseId,
    required this.assignmentId, required this.classworkId,
  });

  @override
  State<AddNewAssignmentItemsDialog> createState() =>
      _AddNewAssignmentItemsDialogState();
}

class _AddNewAssignmentItemsDialogState extends State<AddNewAssignmentItemsDialog> {
  //* Accessing the internal state of the assignment section to retrieve picked files.
  final GlobalKey<CourseAssignmentSectionState> _sectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);

    return Stack(
      children: [
        AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            children: [
              const Icon(
                Icons.upload_file_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Assignment files',
                style: isMobile
                    ? AppStyles.mobileTitleSmallSb
                    : AppStyles.mobileTitleMediumSb,
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: CourseAssignmentSection(
                key: _sectionKey,
                initialItems: const [], // Starting with an empty selection.
              ),
            ),
          ),
          actions: [
            BlocBuilder< AssignmentDetailsCubit, AssignmentDetailsState>(
              builder: (context, crudState) {
                final bool isLoading = crudState is AddAssignmentItemsLoading;

                if (isLoading) return const SizedBox.shrink();

                return Row(
                  children: [
                    Expanded(
                      child: CustomAppButton(
                        label: 'Cancel',
                        height: 40,
                        textColor: AppColors.primaryDark,
                        backgroundColor: AppColors.secondaryLight,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomAppButton(
                        label: 'Confirm',
                        height: 40,
                        textColor: AppColors.whiteLight,
                        backgroundColor: AppColors.primary,
                        onPressed: _handleConfirm,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),

        //* Blocking UI Overlay
        BlocBuilder<AssignmentDetailsCubit, AssignmentDetailsState>(
          builder: (context, crudState) {
            if (crudState is AddAssignmentItemsLoading) {
              return const UploadingOverlay();
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Handles the confirmation logic.
  void _handleConfirm() {
    final allFiles = _sectionKey.currentState?.allPickedFiles ?? [];

    if (allFiles.isNotEmpty) {
      context.read<AssignmentDetailsCubit>().uploadNewItems(
            courseId: widget.courseId,
            assignmentId: widget.assignmentId,
            newFiles: allFiles,
            classworkId: widget.classworkId,
          );
    } else {
      AppToast.warning(
        context,
        'Please select at least one file.',
      );
    }
  }
}