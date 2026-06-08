import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class MobileHeaderSection extends StatelessWidget {
  const MobileHeaderSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_circle_left_outlined,
              color: AppColors.primaryDarkHover,
              size: 32,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Announcement Details',
                style: AppStyles.mobileTitleLargeMd.copyWith(
                  color: AppColors.primaryDarkHover,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
