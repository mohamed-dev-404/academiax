import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_state.dart';

class AddCommentBar extends StatefulWidget {
  const AddCommentBar({super.key, required this.announcementId});
  final String announcementId;
  @override
  State<AddCommentBar> createState() => _AddCommentBarState();
}

class _AddCommentBarState extends State<AddCommentBar> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentActionsCubit, CommentActionsState>(
      listener: (context, state) {
        if (state is AddCommentSuccess) {
          _commentController.clear();
          context.read<AnnouncementsFetchCubit>().fetchAnnouncementDetails(
            announcementId: widget.announcementId,
            showLoading: false,
          );
        } else if (state is AddCommentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.primaryDarkHover.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  filled: true,
                  fillColor: AppColors.primaryLight,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primaryDarkHover.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryHover,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  final content = _commentController.text.trim();
                  if (content.isNotEmpty) {
                    context.read<CommentActionsCubit>().addComment(
                      announcementId: widget.announcementId,
                      content: content,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
