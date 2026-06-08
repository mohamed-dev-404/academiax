import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/mobile/announcement_details_mobile_view.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/web/announcement_details_web_view.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';

class AnnouncementDetailsView extends StatelessWidget {
  const AnnouncementDetailsView({
    super.key,
    required this.announcementId,
  });
  final String announcementId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CommentActionsCubit>(),
      child: AdaptiveLayout(
        mobileLayout: (BuildContext context) {
          return AnnouncementDetailsMobileView(
            announcementId: announcementId,
          );
        },
        webLayout: (BuildContext context) {
          return AnnouncementDetailsWebView(
            announcementId: announcementId,
          );
        },
      ),
    );
  }
}
