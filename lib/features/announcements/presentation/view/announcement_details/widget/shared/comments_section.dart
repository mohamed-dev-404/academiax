import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/cache_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comment_divider.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comment_item.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_state.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
      builder: (context, state) {
        if (state is AnnouncementDetailsFetchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnnouncementDetailsFetchFailure) {
          return SnackBar(
            content: Text(state.errMessage),
          );
        } else if (state is AnnouncementFetchDetailsSuccess) {
          final announcementDetails = state.announcementDetails;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    announcementDetails.comments.isEmpty
                        ? 'No Comments'
                        : 'Comments',
                    style: AppStyles.web30Regular.copyWith(
                      color: AppColors.primaryDarkHover,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: announcementDetails.comments.isEmpty
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
                itemCount: announcementDetails.comments.length,
                itemBuilder: (context, index) {
                  final comment = announcementDetails.comments[index];
                  final academicEmail =
                      GetStorageHelper.read(CacheKeys.academicEmail) ?? '';
                  final currentAcademicId = academicEmail.split('@').first;
                  return Column(
                    children: [
                      CommentItem(
                        name: comment.userName,
                        date: comment.date,
                        text: comment.content,
                        isOwner: comment.authorAcademicId == currentAcademicId,
                        imageUrl: comment.profilePic,
                        onEdit: () {
                          _showEditDialog(context, comment);
                        },
                        onDelete: () {
                          _showDeleteConfirm(context, comment.id);
                        },
                      ),
                      const CommentDivider(),
                    ],
                  );
                },
              ),
              
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  void _showEditDialog(BuildContext context, comment) {
  final controller = TextEditingController(text: comment.content);
  final commentActionsCubit = context.read<CommentActionsCubit>();
    final fetchCubit = context.read<AnnouncementsFetchCubit>();
    String? announcementId;
    if (fetchCubit.state is AnnouncementFetchDetailsSuccess) {
      announcementId = (fetchCubit.state as AnnouncementFetchDetailsSuccess).announcementDetails.id;
    }
  
  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: commentActionsCubit,
      child: BlocConsumer<CommentActionsCubit, CommentActionsState>(
        listener: (context, state) {
          if (state is UpdateCommentSuccess) {
            Navigator.pop(dialogContext); 
            // ممكن هنا تعملي Refresh للبيانات لو حابة
            // عمل الـ Refresh في صمت
              if (announcementId != null) {
                fetchCubit.fetchAnnouncementDetails(
                  announcementId: announcementId,
                  showLoading: false, // بدون لودينج
                );
              }
          }
          if (state is UpdateCommentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Edit Comment'),
            content: TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: state is UpdateCommentLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: state is UpdateCommentLoading
                    ? null
                    : () {
                        context.read<CommentActionsCubit>().updateComment(
                              commentId: comment.id,
                              content: controller.text,
                            );
                      },
                child: state is UpdateCommentLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
    ),
  );
}

  void _showDeleteConfirm(BuildContext context, String commentId) {
    final commentActionsCubit = context.read<CommentActionsCubit>();
    final fetchCubit = context.read<AnnouncementsFetchCubit>();
    String? announcementId;
    if (fetchCubit.state is AnnouncementFetchDetailsSuccess) {
      announcementId = (fetchCubit.state as AnnouncementFetchDetailsSuccess).announcementDetails.id;
    }
  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: commentActionsCubit,
      child: BlocConsumer<CommentActionsCubit, CommentActionsState>(
        listener: (context, state) {
          if (state is DeleteCommentSuccess) {
            Navigator.pop(dialogContext); 
            if (announcementId != null) {
                fetchCubit.fetchAnnouncementDetails(
                  announcementId: announcementId,
                  showLoading: false,
                );
              }
          }
          if (state is DeleteCommentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Delete Comment'),
            content: const Text('Are you sure you want to delete this comment?'),
            actions: [
              TextButton(
                onPressed: state is DeleteCommentLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: state is DeleteCommentLoading
                    ? null
                    : () {
                        context.read<CommentActionsCubit>().deleteComment(commentId: commentId);
                      },
                child: state is DeleteCommentLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    ),
  );
}
}
