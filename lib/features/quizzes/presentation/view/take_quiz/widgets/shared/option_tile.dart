import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final String prefix;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.prefix,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.whiteLight,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.greenLightActive,
            width: 1.5,
          ),
          boxShadow: [
            if (!isSelected)
              const BoxShadow(
                color: AppColors.whiteHover,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: RichText(
          text: TextSpan(
            text: prefix,
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: isSelected
                  ? AppColors.whiteLight
                  : AppColors.primaryDarkActive,
            ),
            children: [
              TextSpan(
                text: text,
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: isSelected
                      ? AppColors.whiteLight
                      : AppColors.primaryDarkActive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
