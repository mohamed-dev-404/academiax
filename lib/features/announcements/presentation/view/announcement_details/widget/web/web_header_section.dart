import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class WebHeaderSection extends StatelessWidget {
  const WebHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: Text(
          'Announcement Details',
          style: AppStyles.webTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
