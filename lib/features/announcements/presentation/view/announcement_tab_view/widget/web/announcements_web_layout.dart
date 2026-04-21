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
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/core/widgets/web/web_main_card.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/web/add_announcement_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_tab_view/widget/shared/delete_announcement_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';

class AnnouncementsWebLayout extends StatelessWidget {
  const AnnouncementsWebLayout({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final bool isInstructor = CurrentRole.role == UserRole.instructor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 12, 40, 0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              'Announcements',
              style: AppStyles.webTitleMediumSb.copyWith(
                color: AppColors.primaryDarkHover,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
            /// [buildWhen] ensures the Grid doesn't disappear when the state shifts
            /// to fetch individual announcement details. It preserves the list view.
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
                final int gridCount = isInstructor
                    ? announcements.length + 1
                    : announcements.length;
                if (gridCount == 0) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No announcements yet.')),
                  );
                }

                return SliverGrid.builder(
                  itemCount: gridCount,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 220,
                    childAspectRatio: 301 / 240,
                  ),
                  itemBuilder: (context, index) {
                    if (isInstructor && index == 0) {
                      return AddNewCard(
                        title: 'New Announcement',
                        isMobile: false,
                        onTap: () async {
                          // Navigate to Create Screen
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) =>
                                AddAnnouncementDialog(courseId: courseId),
                          );
                          if (result == true && context.mounted) {
                            context
                                .read<AnnouncementsFetchCubit>()
                                .fetchAnnouncements(courseId: courseId);
                          }
                        },
                      );
                    }
                    final dataIndex = isInstructor ? index - 1 : index;
                    return WebMainCard(
                      model: MainCardModel(
                        title: announcements[dataIndex].title,
                        description: announcements[dataIndex].content,
                        image: AppImages.imagesAnnouncementCard,
                        actionWidget: (CurrentRole.role == UserRole.instructor)
                            ? SvgPicture.asset(
                                AppIcons.iconsMenu,
                                width: 22,
                                height: 22,
                              )
                            : null,
                        onActionTap: () {
                          if (isInstructor) {
                            _showDeleteDialog(
                              context,
                              announcements[dataIndex].id,
                            );
                          } else {
                            context.push(
                              RoutesName.announcementDetails,
                              extra: {
                                'courseId': courseId,
                                'announcementId': announcements[dataIndex].id,
                              },
                            );
                          }
                        },
                        onTap: () async {
                          /// Fetch specific details before navigating
                          context
                              .read<AnnouncementsFetchCubit>()
                              .fetchAnnouncementDetails(
                                announcementId: announcements[dataIndex].id,
                              );

                          await context.push(
                            RoutesName.announcementDetails,
                            extra: {
                              'courseId': courseId,
                              'announcementId': announcements[dataIndex].id,
                            },
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
                    );
                  },
                );
              } else if (state is AnnouncementsFetchFailure) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(state.errMessage)),
                );
              }

              /// Keep the list visible during details fetching thanks to [buildWhen]
              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
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
