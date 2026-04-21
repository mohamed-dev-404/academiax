import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/cache_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/data/model/comment_details.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/edit_comment_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comment_divider.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comment_item.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/delete_comment_dialog.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
      builder: (context, state) {
        // Flag to trigger the skeleton loading effect
        bool isLoading = state is AnnouncementDetailsFetchLoading;

        if (state is AnnouncementDetailsFetchFailure) {
          return Center(child: Text(state.errMessage));
        }

        // Extract announcement data only if the fetch is successful
        final announcementDetails = (state is AnnouncementFetchDetailsSuccess)
            ? state.announcementDetails
            : null;

        // Safety check: Avoid rendering if there's no data and not in loading state
        if (announcementDetails == null && !isLoading) return const SizedBox();

        return Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    (announcementDetails?.comments.isEmpty ?? true)
                        ? 'No Comments'
                        : 'Comments',
                    style: AppStyles.web30Regular.copyWith(
                      color: AppColors.primaryDarkHover,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Hide badge during loading for a cleaner skeleton look
                  if (!isLoading &&
                      (announcementDetails?.comments.isNotEmpty ?? false))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: announcementDetails!.comments.isEmpty
                            ? Colors.transparent
                            : AppColors.primaryDarkHover,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        announcementDetails.comments.isEmpty
                            ? ''
                            : announcementDetails.comments.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // Show 4 dummy items while loading to fill the screen with skeletons
                itemCount: isLoading ? 4 : announcementDetails!.comments.length,
                itemBuilder: (context, index) {
                  // Provide dummy data during loading so Skeletonizer has a layout to mask
                  final comment = isLoading
                      ? CommentDetails(
                          userName: 'User Name',
                          content:
                              'This is a dummy comment content for loading state',
                          date: 'Date',
                          authorAcademicId: '',
                          id: '',
                          profilePic: '',
                        )
                      : announcementDetails!.comments[index];
                  // Identify the current user to allow edit/delete permissions
                  final academicEmail =
                      GetStorageHelper.read(CacheKeys.academicEmail) ?? '';
                  final currentAcademicId = academicEmail.split('@').first;

                  return Column(
                    children: [
                      CommentItem(
                        name: comment.userName,
                        date: comment.date,
                        text: comment.content,
                        // Ownership logic: Always false during loading, then checked against user ID
                        isOwner: isLoading
                            ? false
                            : comment.authorAcademicId == currentAcademicId,
                        imageUrl: comment.profilePic,
                        onEdit: () => _showEditDialog(context, comment),
                        onDelete: () => _showDeleteConfirm(context, comment.id),
                      ),
                      const CommentDivider(),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Opens a dialog to edit an existing comment
  void _showEditDialog(BuildContext context, CommentDetails comment) {
    final commentActionsCubit = context.read<CommentActionsCubit>();
    final fetchCubit = context.read<AnnouncementsFetchCubit>();
    // Retrieve the announcement ID from the current state to refresh the list later
    String? announcementId;
    if (fetchCubit.state is AnnouncementFetchDetailsSuccess) {
      announcementId = (fetchCubit.state as AnnouncementFetchDetailsSuccess)
          .announcementDetails
          .id;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: commentActionsCubit),
        ],
        child: EditCommentDialog(
          comment: comment,
          announcementId: announcementId,
          fetchCubit: fetchCubit,
        ),
      ),
    );
  }

  /// Opens a confirmation dialog to delete a comment
  void _showDeleteConfirm(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CommentActionsCubit>(),
        child: DeleteCommentDialog(
          commentId: commentId,
          fetchCubit: context.read<AnnouncementsFetchCubit>(),
        ),
      ),
    );
  }
}
