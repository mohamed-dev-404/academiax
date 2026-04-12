import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/announcements/data/repos/announcement_repo.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';

/// Manages fetching operations for announcements (List and Details).
/// It utilizes a "Cache-then-Network" strategy to provide a seamless user experience.
class AnnouncementsFetchCubit extends Cubit<AnnouncementsFetchState>
    with CubitMessageMixin, SafeEmitMixin {
  final AnnouncementsRepo announcementsRepo;
  String? currentCourseId; // هنخزن الـ ID هنا

  AnnouncementsFetchCubit(this.announcementsRepo) : super(AnnouncementsFetchInitial());

  /// Fetches announcements for a specific course.
  /// 1. Immediately emits cached data if available.
  /// 2. Shows a loading indicator if no cache exists.
  /// 3. Synchronizes with remote API and updates the UI with fresh data.
  Future<void> fetchAnnouncements({required String courseId}) async {
    // Phase 1: Try to retrieve data from local storage for instant feedback
    final cachedData = announcementsRepo.getCachedAnnouncements();
    currentCourseId = courseId; // احفظيه فوراً
    if (cachedData.isNotEmpty) {
      emit(AnnouncementsFetchSuccess(cachedData));
    } else {
      // Phase 2: Show loading only if there is no cached data to display
      emit(AnnouncementsFetchLoading());
    }

    // Phase 3: Fetch fresh data from the remote server
    final result = await announcementsRepo.fetchCourseAnnouncements(courseId: courseId);

    result.fold(
      (failure) {
        // If data is already on screen from cache, show an alert (message) instead of an error view
        if (state is AnnouncementsFetchSuccess) {
          emitMessage(failure);
        } else {
          emit(AnnouncementsFetchFailure(failure));
        }
      },
      // Update UI with the latest synchronized data
      (announcements) => emit(AnnouncementsFetchSuccess(announcements)),
    );
  }

  /// Fetches comprehensive details for a specific announcement including its content and comments.
  Future<void> fetchAnnouncementDetails({required String announcementId,bool showLoading = true}) async {
    if (showLoading) {
      emit(AnnouncementDetailsFetchLoading());
    }

    final result = await announcementsRepo.fetchAnnouncementDetails(
      announcementId: announcementId,
    );

    result.fold(
      (failure) => emit(AnnouncementDetailsFetchFailure(failure)),
      (details) => emit(AnnouncementFetchDetailsSuccess(details)),
    );
  }
}