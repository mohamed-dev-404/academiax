import 'package:dartz/dartz.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/data/model/announcement_model.dart';
import 'package:sams_app/features/announcements/data/model/comment_details.dart';
import 'package:sams_app/features/announcements/data/model/comment_request_model.dart';
import 'package:sams_app/features/announcements/data/model/create_announcement_request_model.dart';
import 'package:sams_app/features/announcements/data/model/update_announcement_request_model.dart';

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

  //* --- Instructor Operations ---

  /// Creates a new announcement for a specific course
  Future<Either<String, String>> createAnnouncement({
    required String courseId,
    required CreateAnnouncementRequestModel request,
  });

  /// Updates an existing announcement's title or content
  Future<Either<String, AnnouncementModel>> updateAnnouncement({
    required String announcementId,
    required UpdateAnnouncementRequestModel request,
  });

  /// Deletes an announcement by its ID
  Future<Either<String, String>> deleteAnnouncement({
    required String announcementId,
  });


  //* --- Comment Operations ---

  /// Adds a comment to a specific announcement
  Future<Either<String, Unit>> addComment({
    required String announcementId,
    required CommentRequestModel request,
  });

  /// Updates an existing comment
  Future<Either<String, CommentDetails>> updateComment({
    required String commentId,
    required CommentRequestModel request,
  });

  /// Deletes a comment by its ID
  Future<Either<String, Unit>> deleteComment({
    required String commentId,
  });
}