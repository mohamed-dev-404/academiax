import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// Modal bottom sheet service allowing the instructor to dynamically
/// choose which type of [ApiValues] question they want to append to their quiz.
class AddQuestionBottomSheet {
  /// Displays the modal sheet and fires [onAdd] with the selected question type.
  static void show(
    BuildContext context, {
    required void Function(String type) onAdd,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.whiteActive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Question',
              style: AppStyles.mobileTitleSmallSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose a question type to add.',
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.whiteDarkActive,
              ),
            ),
            const SizedBox(height: 20),
            _buildSheetOption(
              context: context,
              icon: Icons.edit_note_rounded,
              label: 'Written',
              subtitle: 'Free-form text answer',
              onTap: () {
                Navigator.pop(context);
                onAdd(ApiValues.written);
              },
            ),
            const SizedBox(height: 12),
            _buildSheetOption(
              context: context,
              icon: Icons.checklist_rounded,
              label: 'Multiple Choice',
              subtitle: 'Select one correct option',
              onTap: () {
                Navigator.pop(context);
                onAdd(ApiValues.mcq);
              },
            ),
            const SizedBox(height: 12),
            _buildSheetOption(
              context: context,
              icon: Icons.toggle_on_outlined,
              label: 'True / False',
              subtitle: 'Binary true or false answer',
              onTap: () {
                Navigator.pop(context);
                onAdd(ApiValues.trueFalse);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Widget _buildSheetOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.whiteHover, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteDarkActive,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.whiteDarkHover,
            ),
          ],
        ),
      ),
    );
  }
}
