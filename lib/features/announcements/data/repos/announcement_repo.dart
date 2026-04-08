import 'package:dartz/dartz.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/data/model/announcement_model.dart';

//* Abstract contract for announcements data operations
abstract class AnnouncementsRepo {
  
  //* Returns cached announcements from local storage
  List<AnnouncementModel> getCachedAnnouncements();

  //* Fetch announcements for a specific course by courseId
  Future<Either<String, List<AnnouncementModel>>> fetchCourseAnnouncements({
    required String courseId,
  });
  //* Fetch detailed information for a single announcement by announcementId
  Future<Either<String, AnnouncementDetailsModel>> fetchAnnouncementDetails({
    required String announcementId,
  });
}