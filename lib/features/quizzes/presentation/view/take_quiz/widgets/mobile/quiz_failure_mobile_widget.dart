import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/safe_pop_function.dart';

import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';

class QuizFailureMobileWidget extends StatelessWidget {
  final String message;

  const QuizFailureMobileWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.whiteLight,
            AppColors.red.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withValues(alpha: 0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Outer glow container for Lottie
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.red.withValues(alpha: 0.15),
                            blurRadius: 50,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Lottie.asset(
                        AppLottie.error,
                        width: 180,
                        height: 180,
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Quiz Already Submitted',
                      style: AppStyles.mobileTitleLargeMd.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
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
                        color: StatusColors.greyDark.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Hero(
                      tag: 'failure_action',
                      child: CustomAppButton(
                        label: 'Back',
                        backgroundColor: AppColors.primary,
                        onPressed: () => safePop(context: context),
                        borderRadius: 18,
                        height: 60,
                        textStyle: AppStyles.mobileBodyLargeSb.copyWith(
                          color: AppColors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
