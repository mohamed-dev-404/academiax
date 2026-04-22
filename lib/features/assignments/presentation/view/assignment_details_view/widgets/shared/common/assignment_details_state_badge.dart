import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';

class AssignmentDetailsStateBadge extends StatelessWidget {
  const AssignmentDetailsStateBadge({super.key, required this.assignment});

  final AssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, icon) = _getStateStyle(assignment.state);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            assignment.state.name.toUpperCase(),
            style: AppStyles.mobileBodyXsmallMd.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, IconData) _getStateStyle(AssignmentState state) {
    return switch (state) {
      AssignmentState.available || AssignmentState.onGoing => (
        StatusColors.blue,
        AppColors.whiteLight,
        Icons.assignment_outlined,
      ),
      AssignmentState.submitted => (
        StatusColors.green,
        AppColors.whiteLight,
        Icons.check_circle_rounded,
      ),
      AssignmentState.missed || AssignmentState.closed => (
        StatusColors.red.withValues(alpha: 0.1),
        StatusColors.red,
        Icons.error_outline_rounded,
      ),
      _ => (AppColors.whiteHover, StatusColors.greyDark, Icons.help_outline),
    };
  }
}
