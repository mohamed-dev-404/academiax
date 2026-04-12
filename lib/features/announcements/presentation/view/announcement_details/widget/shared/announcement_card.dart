import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/edit_and_delete_announcement_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});
  // final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(

      builder: (context, state) {
        if(state is AnnouncementDetailsFetchLoading) {
          return const Center(child: CircularProgressIndicator());

        } 
        else if(state is AnnouncementFetchDetailsSuccess) {
          final announcementDetails = state.announcementDetails;
          return   Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryDarkHover.withOpacity(0.10),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkHover.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: AppColors.primaryDarkHover,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        announcementDetails.title,
                        style: AppStyles.web30Regular.copyWith(
                          color: AppColors.primaryDarkHover,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        final fetchCubit = context
                            .read<AnnouncementsFetchCubit>();
                        final actionsCubit = context
                            .read<AnnouncementsActionsCubit>();
                        final String? storedCourseId = fetchCubit.currentCourseId;
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: fetchCubit),
                              BlocProvider.value(value: actionsCubit),
                            ],
                            child: EditAndDeleteAnnouncementDialog(
                              announcementId: announcementDetails.id,
                              initialTitle: announcementDetails
                                  .title, 
                              initialContent: announcementDetails
                                  .content, 
                            ),
                          ),
                        );

                        if (context.mounted && result != null) {
                          if (result == 'updated') {
                            fetchCubit.fetchAnnouncementDetails(
                              announcementId: announcementDetails.id,
                              showLoading: false,
                            );
                            if (storedCourseId != null) {
                              fetchCubit.fetchAnnouncements(courseId: storedCourseId);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Announcement updated successfully',
                                ),
                                backgroundColor: AppColors.green

                              ),
                            );
                            // fetchCubit.fetchAnnouncements(courseId: courseId);
                          } else if (result == 'deleted') {
                            // fetchCubit.fetchAnnouncements(courseId: courseId);
                            // تحديث القائمة قبل الـ pop عشان الويب يحس بالتغيير
                            if (storedCourseId != null) {
                              fetchCubit.fetchAnnouncements(courseId: storedCourseId);
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Announcement deleted successfully',
                                ),
                                backgroundColor: AppColors.green

                              ),
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          AppIcons.iconsEditMaterial,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            AppColors.primaryDarkHover.withOpacity(0.7),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),

                // Content
                Text(
                  announcementDetails.content,
                  style: AppStyles.web16Medium.copyWith(
                    color: AppColors.primaryDarker,
                    height: 1.75,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        } 
        else if (state is AnnouncementDetailsFetchFailure) {
          return SnackBar(
            content: Text(state.errMessage),
          );
        }
        return const SizedBox();
      },
    );
  }
}
