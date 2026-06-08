import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/edit_and_delete_announcement_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
      builder: (context, state) {
        // Handling loading state
        final bool isLoading = state is AnnouncementDetailsFetchLoading;

        // Handling failure state
        if (state is AnnouncementDetailsFetchFailure) {
          return Center(child: Text(state.errMessage));
        }

        final announcementDetails = (state is AnnouncementFetchDetailsSuccess)
            ? state.announcementDetails
            : null;

        if (announcementDetails == null && isLoading == false) {
          return const SizedBox();
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryDarkHover.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row with LayoutBuilder to be card-width dependent
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            isLoading
                                ? 'Loading Announcement Title'
                                : announcementDetails!.title,
                            style: AppStyles.webTitleMediumSb.copyWith(
                              color: AppColors.primaryDarkHover,
                              fontSize: (constraints.maxWidth * 0.05).clamp(
                                18,
                                36,
                              ),
                            ),
                            minFontSize: 12,
                            wrapWords: false,
                          ),
                        ),
                        if (!isLoading &&
                            CurrentRole.role == UserRole.instructor) ...[
                          const SizedBox(width: 14),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => _handleEditAndDeleteAction(
                              context,
                              announcementDetails!,
                              announcementDetails.id,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                AppIcons.iconsEditMaterial,
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  AppColors.primaryDarkHover.withValues(
                                    alpha: 0.7,
                                  ),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),

                // Content Section
                Text(
                  isLoading
                      ? 'This is a dummy content for the announcement that spans multiple lines to show the skeleton effect properly.'
                      : announcementDetails!.content,
                  style: AppStyles.web16Medium.copyWith(
                    color: AppColors.primaryDarker,
                    height: 1.75,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Refactored method to handle the logic for updating or deleting an announcement
  Future<void> _handleEditAndDeleteAction(
    BuildContext context,
    AnnouncementDetailsModel announcementDetails,
    String courseId,
  ) async {
    final fetchCubit = context.read<AnnouncementsFetchCubit>();
    final actionsCubit = context.read<AnnouncementsActionsCubit>();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: fetchCubit),
          BlocProvider.value(value: actionsCubit),
        ],
        child: EditAndDeleteAnnouncementDialog(
          announcementId: announcementDetails.id,
          initialTitle: announcementDetails.title,
          initialContent: announcementDetails.content,
        ),
      ),
    );

    if (!context.mounted || result == null) return;

    if (result == 'updated') {
      _onUpdateSuccess(context, fetchCubit, announcementDetails.id, courseId);
    } else if (result == 'deleted') {
      _onDeleteSuccess(context, courseId);
    }
  }

  void _onUpdateSuccess(
    BuildContext context,
    AnnouncementsFetchCubit cubit,
    String id,
    String? courseId,
  ) {
    cubit.fetchAnnouncementDetails(announcementId: id, showLoading: false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Announcement updated successfully'),
        backgroundColor: AppColors.green,
      ),
    );

    if (courseId != null) {
      AnnouncementsFetchCubit.refreshAllLists(courseId);
    }
  }

  void _onDeleteSuccess(BuildContext context, String? courseId) {
    if (courseId != null) {
      AnnouncementsFetchCubit.refreshAllLists(courseId);
    }
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Announcement deleted successfully'),
        backgroundColor: AppColors.green,
      ),
    );
  }
}
