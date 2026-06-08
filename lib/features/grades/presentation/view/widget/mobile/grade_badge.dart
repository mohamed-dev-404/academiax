import 'package:flutter/widgets.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/grades/presentation/view/widget/utils/grade_score_ui_extension.dart';

/// Compact grade badge used in mobile cards.
/// Shows score with colored background based on performance.
class GradeBadge extends StatelessWidget {
  const GradeBadge({
    super.key,
    required this.score,
    required this.maxScore,
  });

  final num? score;
  final num maxScore;

  @override
  Widget build(BuildContext context) {
    final isGraded = score != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: score.getBadgeBackgroundColor(maxScore),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isGraded
            ? '${StudentGradeModel.formatScoreValue(score)}/${StudentGradeModel.formatScoreValue(maxScore)}'
            : 'Not graded',
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: score.getBadgeTextColor(maxScore),
        ),
      ),
    );
  }
}
