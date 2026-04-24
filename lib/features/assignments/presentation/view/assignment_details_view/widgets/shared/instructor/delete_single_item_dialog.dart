import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/assignments/data/model/assignment_item_model.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_state.dart';

class DeleteAssignmentItemDialog extends StatelessWidget {
  final AssignmentItemModel item;
  final String assignmentId;
  final VoidCallback onDelete;

  const DeleteAssignmentItemDialog({
    super.key,
    required this.assignmentId,
    required this.item, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);
    final double screenWidth = SizeConfig.screenWidth(context);

    return AlertDialog(
      backgroundColor: AppColors.whiteLight,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : screenWidth * 0.3,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Remove Attachment?'),
      titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
        color: AppColors.primaryDarkHover,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to remove "${item.originalFileName}" from this assignment?',
            style: AppStyles.mobileBodyMediumRg.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This will permanently delete the file resource.',
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      actions: [
        //* Reactive Logic: Using BlocConsumer to listen for failures and build the UI.
        BlocConsumer<AssignmentDetailsCubit, AssignmentDetailsState>(
          listener: (context, state) {
            //? Fallback: If deletion fails, close dialog and show error.
            if (state is DeleteAssignmentItemFailure) {
              context.pop();
              AppSnackBar.error(context, state.errMessage);
            }
          },
          builder: (context, state) {
            //* Loading State: Show an indicator and disable further actions during the API call.
            if (state is DeleteAssignmentItemLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: AppAnimatedLoadingIndicator(),
                ),
              );
            }

            return Row(
              children: [
                //* Neutral Action: Dismiss without changes.
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

                //* Destructive Action: Proceed with deletion.
                Expanded(
                  child: CustomAppButton(
                    label: 'Delete',
                    height: 40,
                    textColor: AppColors.whiteLight,
                    backgroundColor:
                        StatusColors.red,
                    onPressed: onDelete,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
