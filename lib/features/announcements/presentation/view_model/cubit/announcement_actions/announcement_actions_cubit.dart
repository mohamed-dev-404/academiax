import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/features/announcements/data/model/create_announcement_request_model.dart';
import 'package:sams_app/features/announcements/data/model/update_announcement_request_model.dart';
import 'package:sams_app/features/announcements/data/repos/announcement_repo.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';

class AnnouncementsActionsCubit extends Cubit<AnnouncementsActionsState> {
  final AnnouncementsRepo announcementsRepo;
  

  AnnouncementsActionsCubit(this.announcementsRepo) : super(AnnouncementsActionsInitial());

  // 1- Add Announcement
  Future<void> addAnnouncement({
    required String courseId,
    required String title,
    required String content,
  }) async {
    // emit(AddAnnouncementLoading());
    
    final result = await announcementsRepo.createAnnouncement(
      courseId: courseId,
      request: CreateAnnouncementRequestModel(title: title, content: content),
    );

    result.fold(
      (error) => emit(AddAnnouncementFailure(error)),
      (message) => emit(AddAnnouncementSuccess(message)),
    );
  }

  // 2- Update Announcement
  Future<void> updateAnnouncement({
    required String announcementId,
    String? title,
    String? content,
  }) async {
    // emit(UpdateAnnouncementLoading());

    final result = await announcementsRepo.updateAnnouncement(
      announcementId: announcementId,
      request: UpdateAnnouncementRequestModel(title: title, content: content),
    );

    result.fold(
      (error) => emit(UpdateAnnouncementFailure(error)),
      (updatedModel) => emit(UpdateAnnouncementSuccess('Announcement updated successfully')),
    );
  }

  // 3- Delete Announcement
  Future<void> deleteAnnouncement({required String announcementId}) async {
    // emit(DeleteAnnouncementLoading());

    final result = await announcementsRepo.deleteAnnouncement(
      announcementId: announcementId,
    );

    result.fold(
      (error) => emit(DeleteAnnouncementFailure(error)),
      (message) => emit(DeleteAnnouncementSuccess(message)),
    );
  }
}