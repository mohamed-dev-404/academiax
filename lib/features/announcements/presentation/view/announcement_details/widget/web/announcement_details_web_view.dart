import 'package:flutter/material.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/web/announcement_details_web_view_body.dart';

class AnnouncementDetailsWebView extends StatelessWidget {
  const AnnouncementDetailsWebView({super.key, required this.announcementId});
  final String announcementId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnnouncementDetailsWebViewBody(
          announcementId: announcementId,
        ),
      ),
    );
  }
}
