import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';

class AssignmentStatsRow extends StatelessWidget {
  final AssignmentModel assignment;
  const AssignmentStatsRow({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.attach_file_rounded,
            value: '${assignment.assignmentItems.length}',
            label: 'Files',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            icon: Icons.military_tech_rounded,
            value: '${assignment.points}',
            label: 'Points',
          ),
        ),
        const SizedBox(width: 12),
        // Expanded(
        //   child: _StatItem(
        //     icon: Icons.calendar_today_rounded,
        //     value: assignment.formattedCreatedAt.split(
        //       ',',
        //     )[0],
        //     label: 'Posted',
        //   ),
        // ),
        Expanded(
          child: _StatItem(
            icon: Icons.checklist_rounded,
            value: assignment.enablePlagiarismCheck ? 'Active' : 'Inactive',
            label: 'Plagiarism',
          ),
        ),
      ],
    );
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
