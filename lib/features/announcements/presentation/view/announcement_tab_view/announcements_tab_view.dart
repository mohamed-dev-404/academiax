import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_tab_view/widget/mobile/announcements_mobile_layout.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_tab_view/widget/web/announcements_web_layout.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';

class AnnouncementsTabView extends StatelessWidget {
  final String courseId;
  const AnnouncementsTabView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnnouncementsActionsCubit>(),
      child: AdaptiveLayout(
        mobileLayout: (BuildContext context) {
          return AnnouncementsMobileLayout(
            courseId: courseId,
          );
        },
        webLayout: (BuildContext context) {
          return AnnouncementsWebLayout(
            courseId: courseId,
          );
        },
      ),
    );
  }
}
