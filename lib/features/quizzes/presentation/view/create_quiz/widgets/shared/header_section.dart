import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class HeaderSection extends StatelessWidget {
  final bool isEditMode;
  const HeaderSection({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 50),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * ──────────────────── Badge for mode ────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEditMode ? 'MODIFICATION MODE' : 'NEW QUIZ',
              style: AppStyles.mobileBodyXsmallRg.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),

          const Gap(16),

          // * ──────────────────── Title ────────────────────
          Text(
            isEditMode ? 'Edit Quiz Details' : 'Create New Quiz',
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),

          const Gap(8),

          // * ──────────────────── Description ────────────────────
          Text(
            isEditMode
                ? 'Make sure to double-check the timing and classwork before saving.'
                : 'Fill in the details to set up a new assessment for your class.',
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: AppColors.whiteLight.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
