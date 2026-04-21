import 'package:flutter/material.dart';
import 'package:sams_app/features/announcements/data/model/comment_details.dart';

@immutable
sealed class CommentActionsState {}

final class CommentActionsInitial extends CommentActionsState {}

// --- Add Comment States ---
sealed class AddCommentState extends CommentActionsState {}
final class AddCommentSuccess extends AddCommentState {}
final class AddCommentFailure extends AddCommentState {
  final String errMessage;
  AddCommentFailure(this.errMessage);
}

// --- Update Comment States ---
sealed class UpdateCommentState extends CommentActionsState {}
final class UpdateCommentLoading extends CommentActionsState {}
final class UpdateCommentSuccess extends UpdateCommentState {
  final CommentDetails updatedComment;
  UpdateCommentSuccess(this.updatedComment);
}
final class UpdateCommentFailure extends UpdateCommentState {
  final String errMessage;
  UpdateCommentFailure(this.errMessage);
}

// --- Delete Comment States ---
sealed class DeleteCommentState extends CommentActionsState {}
final class DeleteCommentSuccess extends DeleteCommentState {} 
final class DeleteCommentLoading extends CommentActionsState {}
final class DeleteCommentFailure extends DeleteCommentState {
  final String errMessage;
  DeleteCommentFailure(this.errMessage);
}