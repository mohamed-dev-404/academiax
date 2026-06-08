import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A fixed True/False toggle for TRUE_FALSE question type.
///
/// Shows two radio-style options. In edit/draft mode, the instructor
/// can toggle which is correct. In view mode, it's read-only.
class TrueFalseToggle extends StatelessWidget {
  /// Index of the currently correct option (0 = True, 1 = False).
  final int correctIndex;
  final ValueChanged<int>? onChanged;
  final bool enabled;

  const TrueFalseToggle({
    super.key,
    required this.correctIndex,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOption(
            label: 'True',
            isSelected: correctIndex == 0,
            onTap: enabled ? () => onChanged?.call(0) : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOption(
            label: 'False',
            isSelected: correctIndex == 1,
            onTap: enabled ? () => onChanged?.call(1) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenLight.withAlpha(150)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.whiteActive,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.green : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.green : AppColors.whiteActive,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: isSelected ? AppColors.greenDark : AppColors.whiteDarker,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
