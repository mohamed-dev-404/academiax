import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';

class DeleteAssignmentItemDialog extends StatelessWidget {
  final String fileName;
  final VoidCallback onDeleteConfirmed;

  const DeleteAssignmentItemDialog({
    super.key,
    required this.fileName,
    required this.onDeleteConfirmed,
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
            'Are you sure you want to remove "$fileName" from this assignment?',
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
        Row(
          children: [
            Expanded(
              child: CustomAppButton(
                label: 'Cancel',
                height: 45,
                textColor: AppColors.primaryDark,
                backgroundColor: AppColors.secondaryLight,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: CustomAppButton(
                label: 'Delete',
                height: 45,
                textColor: AppColors.whiteLight,
                backgroundColor: Colors.red.shade600,
                onPressed: () {
                  onDeleteConfirmed(); 
                  context.pop(); 
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
