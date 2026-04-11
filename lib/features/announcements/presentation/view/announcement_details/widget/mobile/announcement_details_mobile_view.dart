import 'package:flutter/material.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/mobile/announcement_details_mobile_view_body.dart';

class AnnouncementDetailsMobileView extends StatelessWidget {
  const AnnouncementDetailsMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF5F7F9),
      body: SafeArea(
        child: AnnouncementDetailsMobileViewBody(
        ),
      ),
    );
  }
}