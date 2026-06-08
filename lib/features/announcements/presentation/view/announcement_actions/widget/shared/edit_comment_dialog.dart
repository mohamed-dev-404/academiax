import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/announcements/data/model/comment_details.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_state.dart';

class EditCommentDialog extends StatefulWidget {
  final CommentDetails comment; // The existing comment model to be edited
  final String? announcementId; // ID needed to refresh data after success
  final AnnouncementsFetchCubit
  fetchCubit; // Reference to the cubit that fetches UI data

  const EditCommentDialog({
    super.key,
    required this.comment,
    this.announcementId,
    required this.fetchCubit,
  });

  @override
  State<EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<EditCommentDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.comment.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic width calculation for Responsiveness (Desktop/Web vs Mobile)
    double dialogWidth = MediaQuery.of(context).size.width > 600
        ? 450
        : MediaQuery.of(context).size.width;

    return BlocConsumer<CommentActionsCubit, CommentActionsState>(
      listener: (context, state) {
        if (state is UpdateCommentSuccess) {
          Navigator.pop(context);
          if (widget.announcementId != null) {
            // Re-fetch details to update the UI with the edited comment
            widget.fetchCubit.fetchAnnouncementDetails(
              announcementId: widget.announcementId!,
              showLoading: false,
            );
          }
        }
        if (state is UpdateCommentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: AppColors.whiteLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Center(child: Text('Edit Comment')),
          titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
          ),
          content: Container(
            width: dialogWidth,
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  prefixIcon: const Icon(Icons.comment_outlined),
                  hintText: 'Your comment',
                  textFieldType: TextFieldType.normal,
                  controller: _controller,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  '• Your edits will be visible to everyone who can see this announcement.',
                  style: AppStyles.mobileBodyMediumRg.copyWith(
                    color: AppColors.primaryDark.withAlpha(220),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          actions: [
            if (state is UpdateCommentLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
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
                      textColor: AppColors.whiteLight,
                      height: 40,
                      label: 'Save',
                      onPressed: () => _handleUpdate(),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  void _handleUpdate() {
    final content = _controller.text.trim();
    if (content.isNotEmpty && content != widget.comment.content) {
      context.read<CommentActionsCubit>().updateComment(
        commentId: widget.comment.id,
        content: content,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a different comment to update.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }
}
