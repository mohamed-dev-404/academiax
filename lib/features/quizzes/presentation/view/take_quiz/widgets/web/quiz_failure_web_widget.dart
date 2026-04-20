import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/safe_pop_function.dart';

import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';

class QuizFailureWebWidget extends StatelessWidget {
  final String message;

  const QuizFailureWebWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            AppColors.whiteLight,
            AppColors.red.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 64.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.red.withValues(alpha: 0.1),
                        blurRadius: 50,
                        offset: const Offset(0, 25),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Glow background for the error animation
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.red.withValues(alpha: 0.15),
                                  blurRadius: 60,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          Lottie.asset(
                            AppLottie.error,
                            width: 220,
                            height: 220,
                            repeat: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Quiz Already Submitted',
                        style: AppStyles.mobileTitleLargeMd.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message.isNotEmpty &&
                                !message.toLowerCase().contains('already')
                            ? message
                            : 'It looks like you have already completed and submitted this quiz. ',
                        style: AppStyles.mobileBodyMediumRg.copyWith(
                          color: StatusColors.greyDark.withValues(alpha: 0.7),
                          fontSize: 19,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 56),
                      CustomAppButton(
                        label: 'Back',
                        backgroundColor: AppColors.primary,
                        onPressed: () => safePop(context: context),
                        borderRadius: 20,
                        height: 68,
                        textStyle: AppStyles.mobileBodyLargeSb.copyWith(
                          color: AppColors.white,
                          fontSize: 22,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
