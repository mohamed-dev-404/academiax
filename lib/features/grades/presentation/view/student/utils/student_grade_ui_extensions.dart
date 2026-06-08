import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/grades/data/model/student_grades/student_grade_model.dart';

extension StudentGradeUIExtension on StudentGradeModel {
  Color get categoryColor {
    final name = classwork.toLowerCase();
    if (name.contains('midterm') || name.contains('final')) {
      return AppColors.red;
    }
    if (name.contains('quiz')) return AppColors.primary;
    if (name.contains('assignment')) return AppColors.secondary;
    if (name.contains('bonus')) return StatusColors.orange;
    return AppColors.primaryDark;
  }

  IconData get categoryIcon {
    final name = classwork.toLowerCase();
    if (name.contains('midterm') || name.contains('final')) {
      return Icons.description_outlined;
    }
    if (name.contains('quiz')) return Icons.quiz_outlined;
    if (name.contains('assignment')) return Icons.assignment_outlined;
    if (name.contains('bonus')) return Icons.star_outline_rounded;
    return Icons.grading_rounded;
  }
}

extension StudentGradesListUIExtension on Iterable<StudentGradeModel> {
  Color get averageScoreColor {
    if (percentage >= 80) return StatusColors.green;
    if (percentage >= 50) return StatusColors.blue;
    return StatusColors.red;
  }

  String get formattedPercentageText => '${percentage.toStringAsFixed(1)}%';

  String get formattedGradedCountText => '$gradedCount / $length';

  String get formattedTotalScoreFractionText =>
      '$formattedTotalScore / $formattedTotalMaxScore';
}
