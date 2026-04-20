import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class InstructionsSection extends StatelessWidget {
  const InstructionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryLightActive.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_rounded, color: AppColors.secondary),
              const SizedBox(width: 12),
              Text('Quiz Instructions', style: AppStyles.mobileTitleSmallSb),
            ],
          ),
          const Divider(height: 40),
          _buildInstructionItem(
            'Make sure you have a stable internet connection.',
          ),
          _buildInstructionItem('Once you start, the timer cannot be paused.'),
          _buildInstructionItem(
            'You cannot go back to a previous question once you move to the next one.',
          ),
          _buildInstructionItem(
            'The quiz will automatically submit when time is up.',
          ),
          _buildInstructionItem(
            'Do not refresh the page or navigate away during the quiz.',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
