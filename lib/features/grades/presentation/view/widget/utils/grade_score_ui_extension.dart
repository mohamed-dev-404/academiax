import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

extension GradeScoreUIExtension on num? {
  /// Background color for mobile badge based on performance percentage
  Color getBadgeBackgroundColor(num maxScore) {
    if (this == null || maxScore == 0) return StatusColors.greyTransparent;
    final pct = (this! / maxScore) * 100;
    if (pct >= 80) return StatusColors.greenTransparent;
    if (pct >= 50) return StatusColors.blueTransparent;
    return StatusColors.redTransparent;
  }

  /// Text color for mobile badge based on performance percentage
  Color getBadgeTextColor(num maxScore) {
    if (this == null || maxScore == 0) return StatusColors.grey;
    final pct = (this! / maxScore) * 100;
    if (pct >= 80) return StatusColors.greenDark;
    if (pct >= 50) return StatusColors.blueDark;
    return StatusColors.redDark;
  }

  /// Text color for web cell based on performance percentage
  Color getWebScoreTextColor(num? maxScore) {
    if (this == null || maxScore == null || maxScore == 0) {
      return AppColors.primaryDark;
    }
    final percentage = (this! / maxScore) * 100;
    if (percentage >= 80) return AppColors.secondary;
    if (percentage >= 50) return AppColors.primaryDark;
    return AppColors.red;
  }
}
