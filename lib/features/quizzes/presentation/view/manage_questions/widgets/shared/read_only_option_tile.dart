import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A read-only option tile for view mode.
///
/// Displays the option text with a visual indicator for the correct answer.
class ReadOnlyOptionTile extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final int index;

  const ReadOnlyOptionTile({
    super.key,
    required this.text,
    required this.isCorrect,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isCorrect
              ? AppColors.greenLight.withAlpha(150)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCorrect
                ? AppColors.greenLightActive
                : AppColors.whiteHover,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // ─── Correct Indicator ───
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect ? AppColors.green : Colors.transparent,
                border: Border.all(
                  color: isCorrect
                      ? AppColors.green
                      : AppColors.whiteActive,
                  width: 2,
                ),
              ),
              child: isCorrect
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),

            // ─── Option Text ───
            Expanded(
              child: Text(
                text.isEmpty ? 'Option ${index + 1}' : text,
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: isCorrect
                      ? AppColors.greenDark
                      : AppColors.blackDark,
                  fontWeight:
                      isCorrect ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),

            // ─── Correct Label ───
            if (isCorrect)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Correct',
                  style: AppStyles.mobileBodyXsmallMd.copyWith(
                    color: AppColors.greenDark,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
