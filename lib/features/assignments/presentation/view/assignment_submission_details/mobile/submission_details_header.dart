import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/shared/general_arrow_back.dart';

class SubmissionDetailsHeader extends StatelessWidget {
  const SubmissionDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      child: Column(
        children: [
          /// Top Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const GeneralArrowBack(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 40),
                const Text(
                  'Student Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// Avatar
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              'MM',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Name
          const Text(
            'Nadia Ashraf Mohamed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          /// ID
          const Text(
            'ID: 202231231',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}