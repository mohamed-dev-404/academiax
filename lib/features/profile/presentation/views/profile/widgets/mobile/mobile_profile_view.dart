import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/profile_main_layout_body.dart';

//* The mobile layout for the profile page.
class MobileProfileView extends StatelessWidget {
  const MobileProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: MobileCustomAppBar(
        titleStyle: AppStyles.mobileTitleLargeMd.copyWith(
          color: AppColors.primaryDarkHover,
        ),
        arrowBackColor: AppColors.primaryDarkHover,
        title: 'Profile',
      ),
      body: const ProfileMainLayoutBody(),
    );
  }
}
