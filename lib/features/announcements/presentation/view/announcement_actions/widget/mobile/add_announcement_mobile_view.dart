import 'package:flutter/material.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/mobile/add_announcement_mobile_view_body.dart';

class AddAnnouncementMobileView extends StatelessWidget {
  const AddAnnouncementMobileView({super.key, required this.courseId});
  final String courseId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: AddAnnouncementMobileViewBody(courseId: courseId)),
    );
  }
}
