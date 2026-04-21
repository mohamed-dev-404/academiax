import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/mobile/mobile_main_card.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_tab_view/widget/shared/delete_announcement_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';

class AnnouncementsMobileLayout extends StatelessWidget {
  const AnnouncementsMobileLayout({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        /// 1. Title Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Announcements',
              style: AppStyles.mobileTitleMediumSb.copyWith(
                color: AppColors.primaryDarkHover,
              ),
            ),
          ),
        ),

        /// 2. Instructor Add Card (Scrolls with the list)
        if (CurrentRole.role == UserRole.instructor)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AddNewCard(
                title: 'Add New Announcement',
                isMobile: true,
                onTap: () async {
                  // Navigate to Create Screen
                  final result = await context.push(
                    RoutesName.addAnnouncement,
                    extra: {
                      'courseId': courseId,
                    },
                  );
                  if (result == true && context.mounted) {
                    context.read<AnnouncementsFetchCubit>().fetchAnnouncements(
                      courseId: courseId,
                    );
                  }
                },
              ),
            ),
          ),

        /// 3. The List of Announcements
        BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
          buildWhen: (previous, current) {
            return current is AnnouncementsFetchLoading ||
                current is AnnouncementsFetchSuccess ||
                current is AnnouncementsFetchFailure;
          },
          builder: (context, state) {
            if (state is AnnouncementsFetchLoading) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AnnouncementsFetchSuccess) {
              final announcements = state.announcements;

              if (announcements.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No announcements yet.')),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MobileMainCard(
                        cardModel: MainCardModel(
                          actionWidget:
                              (CurrentRole.role == UserRole.instructor)
                              ? SvgPicture.asset(
                                  AppIcons.iconsMenu,
                                  width: 22,
                                  height: 22,
                                )
                              : null,
                          onActionTap: () {
                            if (CurrentRole.role == UserRole.instructor) {
                              _showDeleteDialog(
                                context,
                                announcements[index].id,
                              );
                            } else {
                              context.push(
                                RoutesName.announcementDetails,
                                extra: {
                                  'courseId': courseId,
                                  'announcementId': announcements[index].id,
                                },
                              );
                            }
                          },
                          title: announcements[index].title,
                          description: announcements[index].content,
                          image: AppImages.imagesAnnouncementCard,
                          onTap: () async {
                            context
                                .read<AnnouncementsFetchCubit>()
                                .fetchAnnouncementDetails(
                                  announcementId: announcements[index].id,
                                );

                            await context.push(
                              RoutesName.announcementDetails,
                             extra: {
                               'courseId': courseId,
                               'announcementId': announcements[index].id,
                             }
                            );

                            if (context.mounted) {
                              context
                                  .read<AnnouncementsFetchCubit>()
                                  .fetchAnnouncements(
                                    courseId: courseId,
                                  );
                            }
                          },
                        ),
                      ),
                    );
                  },
                  childCount: announcements.length,
                ),
              );
            } else if (state is AnnouncementsFetchFailure) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(state.errMessage)),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox());
          },
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String announcementId,
  ) async {
    final actionsCubit = context.read<AnnouncementsActionsCubit>();
    final fetchCubit = context.read<AnnouncementsFetchCubit>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: actionsCubit,
        child: DeleteAnnouncementDialog(announcementId: announcementId),
      ),
    );

    if (result == 'deleted' && context.mounted) {
      fetchCubit.fetchAnnouncements(courseId: courseId);
    }
  }
}
