import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/presentation/view/student/utils/student_grade_ui_extensions.dart';

/// ─── Summary Row (Web) ───
class GradesSummaryRow extends StatelessWidget {
  const GradesSummaryRow({super.key, required this.allGrades});
  final List<StudentGradeModel> allGrades;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          icon: Icons.grading_rounded,
          label: 'Graded',
          value: allGrades.formattedGradedCountText,
          color: AppColors.primary,
        ),
        const SizedBox(width: 16),
        _SummaryCard(
          icon: Icons.score_rounded,
          label: 'Total Score',
          value: allGrades.formattedTotalScoreFractionText,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 16),
        _SummaryCard(
          icon: Icons.percent_rounded,
          label: 'Percentage',
          value: allGrades.formattedPercentageText,
          color: allGrades.averageScoreColor,
        ),
      ],
    );
  }
}

/// Individual summary card
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20..clamp(18, 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteDarkHover,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
