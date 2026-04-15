import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

//* Overlay showing Lottie animations based on the current operation

class UpdateProgressOverlay extends StatelessWidget {
  final String message;

  const UpdateProgressOverlay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    String lottieAsset;

    //? Check message content to decide which animation to show
    if (message.contains('Deleting')) {
      lottieAsset = AppLottie.delete;
    } else if (message.contains('Uploading')) {
      lottieAsset = AppLottie.uploadFiles;
    } else {
      //! Default fallback to edit animation
      lottieAsset = AppLottie.edit;
    }

    return Container(
      color: AppColors.primaryDarker.withAlpha(230),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              lottieAsset,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppStyles.mobileBodyLargeSb.copyWith(
                color: AppColors.whiteLight,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please stay on this screen until completion.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteDark,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
