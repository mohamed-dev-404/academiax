import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/safe_pop_function.dart';

class QuizSuccessWebWidget extends StatelessWidget {
  const QuizSuccessWebWidget({super.key});

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

        // Success Card
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(
                horizontal: 48.0,
                vertical: 60.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteLight.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 40,
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
                    width: 250,
                    height: 250,
                    repeat: true,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Awesome!',
                    style: AppStyles.webTitleMediumSb.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Exam Has Been Successfully Submitted. You can safely leave this screen now.',
                    style: AppStyles.webBodySmallRg.copyWith(
                      color: StatusColors.greyDark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  CustomAppButton(
                    label: 'Finish',
                    onPressed: () => safePop(context: context),
                    backgroundColor: AppColors.primary,
                    borderRadius: 20,
                    height: 64,
                    textStyle: AppStyles.webBodySmallSb.copyWith(
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
