import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_state.dart';

class DeleteCommentDialog extends StatelessWidget {
  final String commentId;
  final AnnouncementsFetchCubit fetchCubit;

  const DeleteCommentDialog({
    super.key,
    required this.commentId,
    required this.fetchCubit,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the current Announcement ID from the fetchCubit's state
    // This allows us to refresh the specific announcement list after deletion
    String? announcementId;
    if (fetchCubit.state is AnnouncementFetchDetailsSuccess) {
      announcementId = (fetchCubit.state as AnnouncementFetchDetailsSuccess)
          .announcementDetails
          .id;
    }

    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<CommentActionsCubit, CommentActionsState>(
      listener: (context, state) {
        if (state is DeleteCommentSuccess) {
          Navigator.pop(context);
          if (announcementId != null) {
            fetchCubit.fetchAnnouncementDetails(
              announcementId: announcementId,
              showLoading: false,
            );
          }
        }
        if (state is DeleteCommentFailure) {
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
            horizontal: isMobile ? 20 : screenWidth * 0.25,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Delete Comment?'),
          titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Are you sure you want to delete this comment?',
                style: AppStyles.mobileBodyMediumRg.copyWith(
                  color: AppColors.primaryDark,
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
            if (state is DeleteCommentLoading)
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
                        context.read<CommentActionsCubit>().deleteComment(
                          commentId: commentId,
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
