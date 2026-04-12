import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// Dialog helper for confirming the deletion of a quiz question.
class DeleteQuestionDialog {
  /// Displays the confirmation dialog.
  static void show(BuildContext context, {required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Warning Icon ───
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.redLight.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: AppColors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),

              // ─── Title ───
              Text(
                'Delete Question?',
                style: AppStyles.mobileTitleMediumSb.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),

              // ─── Description ───
              Text(
                'Are you sure you want to remove this question? This action is permanent and cannot be reversed.',
                textAlign: TextAlign.center,
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkActive,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // ─── Action Buttons ───
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.whiteActive),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: AppStyles.mobileBodySmallMd.copyWith(
                          color: AppColors.whiteDarkActive,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: Text(
                        'Delete',
                        style: AppStyles.mobileBodySmallMd.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
