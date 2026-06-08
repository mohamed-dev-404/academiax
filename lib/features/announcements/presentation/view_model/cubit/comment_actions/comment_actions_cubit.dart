import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/announcements/data/model/comment_request_model.dart';
import 'package:sams_app/features/announcements/data/repos/announcement_repo.dart';
import 'comment_actions_state.dart';

class CommentActionsCubit extends Cubit<CommentActionsState> {
  final AnnouncementsRepo announcementsRepo;

  CommentActionsCubit(this.announcementsRepo) : super(CommentActionsInitial());

  // 1- Add Comment
  Future<void> addComment({
    required String announcementId,
    required String content,
  }) async {
    final result = await announcementsRepo.addComment(
      announcementId: announcementId,
      request: CommentRequestModel(content: content),
    );

    result.fold(
      (error) => emit(AddCommentFailure(error)),
      (_) => emit(AddCommentSuccess()),
    );
  }

  // 2- Update Comment
  Future<void> updateComment({
    required String commentId,
    required String content,
  }) async {
    emit(UpdateCommentLoading());
    final result = await announcementsRepo.updateComment(
      commentId: commentId,
      request: CommentRequestModel(content: content),
    );

    result.fold(
      (error) => emit(UpdateCommentFailure(error)),
      (updatedComment) => emit(UpdateCommentSuccess(updatedComment)),
    );
  }

  // 3- Delete Comment
  Future<void> deleteComment({required String commentId}) async {
    emit(DeleteCommentLoading());

    final result = await announcementsRepo.deleteComment(
      commentId: commentId,
    );

    result.fold(
      (error) => emit(DeleteCommentFailure(error)),
      (_) => emit(DeleteCommentSuccess()),
    );
  }
}
