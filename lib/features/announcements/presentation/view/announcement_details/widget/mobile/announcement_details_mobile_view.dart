import 'package:flutter/material.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/mobile/announcement_details_mobile_view_body.dart';

class AnnouncementDetailsMobileView extends StatelessWidget {
  const AnnouncementDetailsMobileView({super.key, required this.announcementId,});
  final String announcementId;
  // final String courseId;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xffF5F7F9),
      body: SafeArea(
        child: AnnouncementDetailsMobileViewBody(announcementId:announcementId),
      ),
    );
  }
}