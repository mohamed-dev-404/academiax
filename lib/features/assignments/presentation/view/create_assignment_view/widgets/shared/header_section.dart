import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = SizeConfig.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, isMobile ? 60 : 20, 20, 50),
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
          isMobile
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.whiteLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

          // * ──────────────────── Badge for mode ────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'NEW ASSIGNMENT',
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
            'Create New Assignment',
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),

          const Gap(8),

          // * ──────────────────── Description ────────────────────
          Text(
            'Fill in the details to set up a new assessment for your class.',
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: AppColors.whiteLight.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
