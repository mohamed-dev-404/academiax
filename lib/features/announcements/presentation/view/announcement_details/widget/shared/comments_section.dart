import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comment_divider.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comment_item.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Comments',
              style: AppStyles.web30Regular.copyWith(
                color: AppColors.primaryDarkHover,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkHover,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '2',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const CommentItem(
          name: 'Nadia Ashraf',
          date: 'Mar 5',
          text:
              'The make-up quiz will be held tomorrow at 8:45 AM in lab 6302.',
        ),
        const CommentDivider(),
        const CommentItem(
          name: 'Nadia Ashraf',
          date: 'Mar 5',
          text:
              'The make-up quiz will be held tomorrow at 8:45 AM in lab 6302.',
        ),
        const CommentDivider(),
        const CommentItem(
          name: 'Nadia Ashraf',
          date: 'Mar 5',
          text:
              'The make-up quiz will be held tomorrow at 8:45 AM in lab 6302.',
        ),
        const CommentDivider(),
        const CommentItem(
          name: 'Nadia Ashraf',
          date: 'Mar 5',
          text:
              'The make-up quiz will be held tomorrow at 8:45 AM in lab 6302.',
        ),
        const CommentDivider(),
        const CommentItem(
          name: 'Nadia Ashraf',
          date: 'Mar 5',
          text:
              'The make-up quiz will be held tomorrow at 8:45 AM in lab 6302nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnbbbbbbbb.',
        ),
      ],
    );
  }
}