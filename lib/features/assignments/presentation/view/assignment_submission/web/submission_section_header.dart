import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class SubmissionSectionHeader extends StatelessWidget {
  const SubmissionSectionHeader({
    super.key,
    required this.label,
    required this.dotColor,
  });

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 4, height: 24, color: dotColor),
          const SizedBox(width: 12),
          Text(label, style: AppStyles.mobileBodyXXlargeMd),
        ],
      ),
    );
  }
}