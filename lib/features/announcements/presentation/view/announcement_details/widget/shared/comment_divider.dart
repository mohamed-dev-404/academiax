import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

class CommentDivider extends StatelessWidget {
  const CommentDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, top: 4, bottom: 4),
      child: Divider(
        height: 24,
        color: AppColors.primaryDarkHover.withOpacity(0.08),
      ),
    );
  }
}