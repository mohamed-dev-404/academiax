import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/mobile/mobile_main_card.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';

class AnnouncementsMobileLayout extends StatelessWidget {
  const AnnouncementsMobileLayout({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Announcements',
          style: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
            builder: (context, state) {
              if (state is AnnouncementsFetchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AnnouncementsFetchSuccess) {
                final announcements = state.announcements;
                if (announcements.isEmpty) {
                  return const Center(
                    child: Text('No announcements yet.'),
                  );
                }
                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MobileMainCard(
                        cardModel: MainCardModel(
                          title: announcements[index].title,
                          description: announcements[index].content,
                          image: AppImages.imagesAnnouncementCard,
                          onTap: () {
                            context.pushNamed(
                              RoutesName.announcementDetails,
                              pathParameters: {
                                'courseId': courseId,
                                'announcementId': announcements[index].id,
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (state is AnnouncementsFetchFailure) {
                return Center(child: Text(state.errMessage));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
