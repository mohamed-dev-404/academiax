import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/mobile/announcement_details_mobile_view.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/web/announcement_details_web_view.dart';

class AnnouncementDetailsView extends StatelessWidget {
  const AnnouncementDetailsView({super.key, });
  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (BuildContext context) {
        return const AnnouncementDetailsMobileView();
      },
      webLayout: (BuildContext context) {
        return  const AnnouncementDetailsWebView();
      },
    );
  }
}
