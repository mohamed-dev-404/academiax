import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/safe_pop_function.dart';

class QuizSuccessMobileWidget extends StatelessWidget {
  const QuizSuccessMobileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Fireworks Background
        Positioned.fill(
          child: Lottie.asset(
            AppLottie.fireWorks,
            fit: BoxFit.cover,
            repeat: true,
          ),
        ),

        // * Success Card
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteLight.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    AppLottie.success,
                    width: 180,
                    height: 180,
                    repeat: true,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Awesome!',
                    style: AppStyles.mobileTitleLargeMd.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Exam Has Been Successfully Submitted. You can safely leave this screen now.',
                    style: AppStyles.mobileBodyMediumRg.copyWith(
                      color: StatusColors.greyDark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomAppButton(
                    label: 'Finish',
                    backgroundColor: AppColors.primary,
                    onPressed: () => safePop(context: context),
                    borderRadius: 16,
                    height: 56,
                    textStyle: AppStyles.mobileBodyLargeSb.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
