import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';

class DeleteAnnouncementDialog extends StatelessWidget {
  final String announcementId;

  const DeleteAnnouncementDialog({
    super.key,
    required this.announcementId,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the current Announcement ID from the fetchCubit's state
    // This allows us to refresh the specific announcement list after deletion

    final bool isMobile = SizeConfig.isMobile(context);
    final double screenWidth = SizeConfig.screenWidth(context);

    return BlocConsumer<AnnouncementsActionsCubit, AnnouncementsActionsState>(
      listener: (context, state) {
        if (state is DeleteAnnouncementSuccess) {
          Navigator.pop(context, 'deleted');
        }
        if (state is DeleteAnnouncementFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: AppColors.whiteLight,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : screenWidth * 0.27,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Delete Announcement?'),
          titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
            fontSize: isMobile ? screenWidth * 0.06 : screenWidth * 0.025,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Are you sure you want to delete this announcement? This action cannot be undone.',
                style: AppStyles.mobileBodyMediumRg.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: isMobile ? screenWidth * 0.04 : screenWidth * 0.018,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          actionsPadding: const EdgeInsets.only(
            top: 10,
            bottom: 20,
            left: 16,
            right: 16,
          ),
          actions: [
            if (state is DeleteAnnouncementLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: CustomAppButton(
                      label: 'Cancel',
                      height: 40,
                      textColor: AppColors.primaryDark,
                      backgroundColor: AppColors.secondaryLight,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomAppButton(
                      label: 'Delete',
                      height: 40,
                      textColor: AppColors.whiteLight,
                      backgroundColor: Colors.red,
                      onPressed: () {
                        context
                            .read<AnnouncementsActionsCubit>()
                            .deleteAnnouncement(
                              announcementId: announcementId,
                            );
                      },
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
