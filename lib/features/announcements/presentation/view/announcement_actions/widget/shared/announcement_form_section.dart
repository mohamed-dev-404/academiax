import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class AnnouncementFormSection extends StatelessWidget {
  const AnnouncementFormSection({
    super.key,
    required this.titleController,
    required this.contentController,
    this.isEdit = false, 
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Announcement Title',
          style: AppStyles.mobileTitleXsmallMd.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: titleController,
          validator: (value) {
           
            if (!isEdit && (value == null || value.isEmpty)) {
              return 'Title cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter announcement title',
            hintStyle: AppStyles.mobileBodySmallRg.copyWith(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Announcement Description',
          style: AppStyles.mobileTitleXsmallMd.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: contentController,
          maxLines: 5,
          validator: (value) {
            if (!isEdit && (value == null || value.isEmpty)) {
              return 'Content cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter announcement content',
            hintStyle: AppStyles.mobileBodySmallRg.copyWith(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
