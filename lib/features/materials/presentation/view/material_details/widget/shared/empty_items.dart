import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// A descriptive placeholder widget displayed when a material has no attached files.
/// It utilizes Lottie animations for a modern, interactive user experience.
class EmptyItems extends StatelessWidget {
  const EmptyItems({super.key});

  @override
  Widget build(BuildContext context) {
    //* Responsiveness: Adjusting asset dimensions based on the device type.
    final isMobile = SizeConfig.isMobile(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, //? Center content within its parent.
        children: [
          //* Visual Feedback: Lottie animation provides a more engaging "Empty State" than static images.
          Lottie.asset(
            AppLottie.empty,
            width: isMobile ? 180 : 220,
            height: isMobile ? 180 : 220,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 16),

          //* Informative Message: Clear communication with the user about the missing content.
          Text(
            'No files attached to this material.',
            style: (isMobile)
                ? AppStyles.mobileBodySmallRg
                : AppStyles.web15Regular,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
