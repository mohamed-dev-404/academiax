import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';

//* A dialog widget that confirms the user's intention to log out, providing options to cancel or proceed with the logout action.
class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);
    final double screenWidth = SizeConfig.screenWidth(context);

    return AlertDialog(
      backgroundColor: AppColors.whiteLight,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : screenWidth * 0.18,
        vertical: 24,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      title: const Center(
        child: Icon(
          Icons.logout,
          color: AppColors.red,
          size: 42,
        ),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
            style: AppStyles.mobileBodyMediumRg.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),

      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),

      actions: [
        Row(
          children: [
            Expanded(
              child: CustomAppButton(
                height: 40,
                label: 'Cancel',
                textColor: AppColors.primaryDark,
                backgroundColor: AppColors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: CustomAppButton(
                height: 40,
                label: 'Logout',
                textColor: AppColors.whiteLight,
                backgroundColor: AppColors.red,
                onPressed: () {
                  // Perform the logout action using the ProfileCubit and close the dialog
                  context.read<ProfileCubit>().logout();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
