import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class SubmissionsStatsBar extends StatelessWidget {
  final int totalSubmitted;
  final int totalMarked;
  final int totalUnmarked;

  const SubmissionsStatsBar({
    super.key,
    required this.totalSubmitted,
    required this.totalMarked,
    required this.totalUnmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryActive.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn('Submitted', totalSubmitted, AppColors.white),
          _buildDivider(),

          _buildStatColumn('Marked', totalMarked, StatusColors.green),
          _buildDivider(),

          _buildStatColumn('Unmarked', totalUnmarked, StatusColors.orangeDark),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: AppStyles.webBodySmallSb.copyWith(
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppStyles.web16Medium.copyWith(
            color: color.withValues(
              alpha: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.white.withValues(alpha: 0.2),
    );
  }
}
