import 'package:flutter/material.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';

class AssignmentActionCard extends StatelessWidget {
  const AssignmentActionCard({
    super.key,
    required this.onPressed,
    required this.assignment,
  });

  final void Function() onPressed;
  final AssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    final state = assignment.state;

    // UI Configuration based on state
    final (title, icon, showButton, buttonLabel) = _getActionConfig(state);

    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _getBgColor(state),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _getBorderColor(state)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: _getIconColor(state), size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppStyles.mobileBodyLargeSb.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          _buildDescription(state),
          if (showButton) ...[
            const SizedBox(height: 24),
            AppButton(
              model: AppButtonStyleModel(
                label: buttonLabel,
                onPressed: onPressed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  (String, IconData, bool, String) _getActionConfig(AssignmentState state) {
    return switch (state) {
      AssignmentState.available => (
        'Ready to Submit?',
        Icons.cloud_upload_outlined,
        true,
        'Upload Assignment',
      ),
      AssignmentState.submitted => (
        'Handed In',
        Icons.check_circle_outline_rounded,
        false,
        '',
      ),
      AssignmentState.missed => (
        'Assignment Missed',
        Icons.event_busy_rounded,
        false,
        '',
      ),
      AssignmentState.onGoing => (
        'Active Assignment',
        Icons.pending_actions_rounded,
        false,
        '',
      ),
      _ => ('Restricted', Icons.lock_outline_rounded, false, ''),
    };
  }

  Widget _buildDescription(AssignmentState state) {
    final style = AppStyles.mobileBodyXsmallRg.copyWith(
      color: AppColors.secondary,
    );
    return Text.rich(
      TextSpan(
        style: style,
        children: switch (state) {
          AssignmentState.available => [
            const TextSpan(text: 'Final deadline: '),
            TextSpan(
              text: assignment.formattedDueDate,
              style: const TextStyle(
                color: StatusColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          AssignmentState.submitted => [
            const TextSpan(text: 'Your submission is being reviewed.'),
          ],
          AssignmentState.missed => [
            const TextSpan(
              text: 'Deadline passed on ',
              style: TextStyle(color: StatusColors.red),
            ),
            TextSpan(
              text: assignment.formattedDueDate,
              style: const TextStyle(
                color: StatusColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          _ => [const TextSpan(text: 'No actions available at this time.')],
        },
      ),
      textAlign: TextAlign.center,
    );
  }

  Color _getBgColor(AssignmentState state) => switch (state) {
    AssignmentState.submitted => StatusColors.green.withValues(alpha: 0.1),
    AssignmentState.missed => StatusColors.red.withValues(alpha: 0.1),
    _ => AppColors.primaryLight.withValues(alpha: 0.2),
  };

  Color _getBorderColor(AssignmentState state) => switch (state) {
    AssignmentState.submitted => StatusColors.green.withValues(alpha: 0.3),
    AssignmentState.missed => StatusColors.red.withValues(alpha: 0.3),
    _ => AppColors.primaryLightActive,
  };

  Color _getIconColor(AssignmentState state) => switch (state) {
    AssignmentState.submitted => StatusColors.green,
    AssignmentState.missed => StatusColors.red,
    _ => AppColors.primary,
  };
}
