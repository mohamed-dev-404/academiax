import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';

/// A single selectable row inside the classwork picker.
///
/// Shows a radio-style indicator, the classwork name, and its points.
class ClassworkTile extends StatelessWidget {
  final ClassworkItemModel item;
  final bool isSelected;
  final VoidCallback onTap;

  const ClassworkTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryLight : AppColors.whiteLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.whiteHover,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _buildRadioIndicator(),
            const SizedBox(width: 14),
            _buildLabels(),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.secondary : AppColors.whiteDarkHover,
          width: 2,
        ),
        color: isSelected ? AppColors.secondary : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }

  Widget _buildLabels() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: AppStyles.mobileBodySmallMd.copyWith(
              color: isSelected
                  ? AppColors.primaryDarkHover
                  : AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${item.points} points',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.whiteDarkActive,
            ),
          ),
        ],
      ),
    );
  }
}
