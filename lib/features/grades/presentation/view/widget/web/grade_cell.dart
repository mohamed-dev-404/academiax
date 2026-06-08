import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/grades/presentation/view/widget/utils/grade_score_ui_extension.dart';

/// Reusable grade cell widget used in both table and card views.
/// Handles null scores gracefully with "—" placeholder.
class GradeCell extends StatelessWidget {
  const GradeCell({
    super.key,
    required this.score,
    this.maxScore,
    this.showMax = false,
  });

  /// The student's score. Null means "Not graded yet".
  final num? score;

  /// Maximum possible score for reference.
  final num? maxScore;

  /// Whether to show the max score alongside (e.g. "8/10").
  final bool showMax;

  @override
  Widget build(BuildContext context) {
    if (score == null) {
      return Text(
        '—',
        style: AppStyles.mobileBodySmallRg.copyWith(
          color: StatusColors.grey,
        ),
        textAlign: TextAlign.center,
      );
    }

    final scoreText = showMax && maxScore != null
        ? '${StudentGradeModel.formatScoreValue(score)}/${StudentGradeModel.formatScoreValue(maxScore)}'
        : StudentGradeModel.formatScoreValue(score);

    return Text(
      scoreText,
      style: AppStyles.mobileBodySmallMd.copyWith(
        color: score.getWebScoreTextColor(maxScore),
      ),
      textAlign: TextAlign.center,
    );
  }
}
