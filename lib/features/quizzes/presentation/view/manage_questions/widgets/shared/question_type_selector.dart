import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A row of selectable chips for choosing the question type.
///
/// Shows three chips: Written, MCQ, True/False.
/// Disabled when [enabled] is false (view mode).
class QuestionTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const QuestionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.enabled = true,
  });

  static const _types = [
    (label: 'Written', value: ApiValues.written, icon: Icons.edit_note_rounded),
    (label: 'MCQ', value: ApiValues.mcq, icon: Icons.checklist_rounded),
    (
      label: 'True / False',
      value: ApiValues.trueFalse,
      icon: Icons.toggle_on_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _types.map((type) {
        final isSelected = selectedType == type.value;
        return _buildChip(
          label: type.label,
          icon: type.icon,
          isSelected: isSelected,
          onTap: enabled ? () => onChanged(type.value) : null,
        );
      }).toList(),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final bgColor = isSelected
        ? AppColors.primaryLight
        : (enabled ? AppColors.white : AppColors.whiteHover);
    final borderColor = isSelected ? AppColors.primary : AppColors.whiteActive;
    final textColor = isSelected
        ? AppColors.primaryDark
        : (enabled ? AppColors.whiteDarker : AppColors.whiteDarkActive);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppStyles.mobileBodyXsmallMd.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
