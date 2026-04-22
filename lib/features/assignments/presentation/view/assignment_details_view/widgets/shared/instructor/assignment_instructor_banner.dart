import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';

class AssignmentInstructorBanner extends StatelessWidget {
  final AssignmentModel assignment;
  const AssignmentInstructorBanner({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return switch (assignment.state) {
      AssignmentState.onGoing => const _ContextualBanner(
        icon: Icons.info_outline_rounded,
        color: StatusColors.orange,
        title: 'Active Assignment',
        message:
            'Students are currently working on this. You can still add reference materials.',
      ),
      AssignmentState.closed => const _ContextualBanner(
        icon: Icons.lock_clock_rounded,
        color: StatusColors.red,
        title: 'Deadline Reached',
        message:
            'The submission period has ended. You can now start reviewing and grading submissions.',
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ContextualBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const _ContextualBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.mobileBodyLargeSb.copyWith(color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppStyles.mobileBodySmallRg.copyWith(
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
