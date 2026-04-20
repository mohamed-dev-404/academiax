import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// An editable option tile for MCQ questions.
///
/// Displays: [radio button] [text field] [delete button]
/// The radio indicates if this option is the correct answer.
class EditableOptionTile extends StatelessWidget {
  final TextEditingController controller;
  final bool isCorrect;
  final int index;
  final VoidCallback onToggleCorrect;
  final VoidCallback? onRemove;
  final ValueChanged<String>? onChanged;
  final bool canRemove;

  const EditableOptionTile({
    super.key,
    required this.controller,
    required this.isCorrect,
    required this.index,
    required this.onToggleCorrect,
    this.onRemove,
    this.onChanged,
    this.canRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // ─── Correct Answer Radio ───
          GestureDetector(
            onTap: onToggleCorrect,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect
                    ? AppColors.green
                    : Colors.transparent,
                border: Border.all(
                  color: isCorrect
                      ? AppColors.green
                      : AppColors.whiteActive,
                  width: 2,
                ),
              ),
              child: isCorrect
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // ─── Option Text ───
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.blackDark,
              ),
              decoration: InputDecoration(
                hintText: 'Option ${index + 1}',
                hintStyle: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkHover,
                ),
                filled: true,
                fillColor: isCorrect
                    ? AppColors.greenLight.withAlpha(100)
                    : AppColors.whiteLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isCorrect
                        ? AppColors.greenLightActive
                        : AppColors.whiteHover,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // ─── Delete Button ───
          if (canRemove && onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.redLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
