import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/mobile/add_announcement_mobile_view.dart';

class AddAnnouncementLayout extends StatelessWidget {
  const AddAnnouncementLayout({super.key, required this.courseId});
  final String courseId ;
  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) => AddAnnouncementMobileView(courseId: courseId),
      webLayout: (context) =>  const SizedBox.shrink(),
    );
  }
}
