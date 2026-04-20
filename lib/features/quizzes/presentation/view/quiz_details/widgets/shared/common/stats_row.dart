import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

class StatsRow extends StatelessWidget {
  final QuizModel quiz;
  const StatsRow({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.format_list_bulleted_rounded,
            value: '${quiz.numberOfQuestions}',
            label: 'Questions',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            icon: Icons.military_tech_rounded,
            value: '${quiz.totalScore}',
            label: 'Points',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            icon: Icons.schedule_rounded,
            value: _formatTime(quiz.totalTime),
            label: 'Total time',
          ),
        ),
      ],
    );
  }

  String _formatTime(num totalSeconds) {
    final int seconds = totalSeconds.toInt();
    if (seconds < 60) return '${seconds}s';

    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    if (minutes >= 60) {
      final int hours = minutes ~/ 60;
      final int remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) return '${hours}h';
      return '${hours}h ${remainingMinutes}m';
    }

    if (remainingSeconds == 0) return '${minutes}m';
    return '${minutes}m ${remainingSeconds}s';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLightActive, width: 1.5),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLight,
            child: Icon(icon, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppStyles.mobileBodyLargeSb.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppStyles.mobileBodyXsmallRg.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
