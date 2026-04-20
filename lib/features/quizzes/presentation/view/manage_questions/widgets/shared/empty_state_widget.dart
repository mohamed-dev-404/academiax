import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

/// An empty state widget shown in Draft mode when no questions exist yet.
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAddFirst;

  const EmptyStateWidget({super.key, this.onAddFirst});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ─── Icon ───
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Lottie.asset(AppLottie.empty),
        ),
        const SizedBox(height: 24),

        // ─── Title ───
        Text(
          'No Questions Yet',
          style: AppStyles.mobileTitleSmallSb.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),

        // ─── Subtitle ───
        Text(
          'Start building your quiz by tapping the\nbutton below to add your first question.',
          textAlign: TextAlign.center,
          style: AppStyles.mobileBodySmallRg.copyWith(
            color: AppColors.whiteDarkActive,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        // ─── CTA Button ───
        if (onAddFirst != null)
          GestureDetector(
            onTap: onAddFirst,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add First Question',
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
