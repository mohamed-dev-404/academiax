import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/mobile/mobile_header_section.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/add_comment_bar.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/announcement_card.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comments_section.dart';

class AnnouncementDetailsMobileViewBody extends StatelessWidget {
  const AnnouncementDetailsMobileViewBody({super.key, required this.announcementId,});
  final String announcementId;
  // final String courseId;
  @override
  Widget build(BuildContext context) {
    return    Column(
      children: [
        const MobileHeaderSection(
      
        ),
         const Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                AnnouncementCard(),
                SizedBox(height: 20),
                CommentsSection(),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
        AddCommentBar(announcementId: announcementId,),
      ],
    );
  }
}














