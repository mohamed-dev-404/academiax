import 'package:dartz/dartz.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/features/announcements/data/data_sources/announcements_local_data_source.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/data/model/announcement_model.dart';
import 'package:sams_app/features/announcements/data/model/comment_details.dart';
import 'package:sams_app/features/announcements/data/model/comment_request_model.dart';
import 'package:sams_app/features/announcements/data/model/create_announcement_request_model.dart';
import 'package:sams_app/features/announcements/data/model/update_announcement_request_model.dart';
import 'package:sams_app/features/announcements/data/repos/announcement_repo.dart';

//* Handles all announcements-related API calls and local caching
class AnnouncementsRepoImpl implements AnnouncementsRepo {
  final ApiConsumer api;
  final AnnouncementLocalDataSource localDataSource;

  AnnouncementsRepoImpl({
    required this.api,
    required this.localDataSource,
  });

  //* GET → fetch announcements by courseId → cache locally → return list
  @override
  Future<Either<String, List<AnnouncementModel>>> fetchCourseAnnouncements({
    required String courseId,
  }) async {
    try {
      final response = await api.get(
        EndPoints.getCourseAnnouncements(courseId),
      );

      List<AnnouncementModel> announcements =
          (response[ApiKeys.data] as List?)
              ?.map((item) => AnnouncementModel.fromJson(item))
              .toList() ??
          [];

      //* cache announcements locally
      await localDataSource.cacheAnnouncements(announcements);

      return right(announcements);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* Returns announcements from local cache without network call
  @override
  List<AnnouncementModel> getCachedAnnouncements() {
    return localDataSource.getCachedAnnouncements();
  }

  //* GET → Fetch specific announcement details by announcementId
  @override
  Future<Either<String, AnnouncementDetailsModel>> fetchAnnouncementDetails({
    required String announcementId,
  }) async {
    try {
      final response = await api.get(
        EndPoints.getAnnouncementDetails(announcementId),
      );

      //* Parse single announcement object from response data
      final announcementDetails = AnnouncementDetailsModel.fromJson(
        response[ApiKeys.data],
      );

      return right(announcementDetails);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  //* POST → Create a new announcement
  Future<Either<String, String>> createAnnouncement({
    required String courseId,
    required CreateAnnouncementRequestModel request,
  }) async {
    try {
      final response = await api.post(
        EndPoints.createAnnouncement(courseId),
        data: request.toJson(),
      );

      final successMessage =
          response[ApiKeys.message] ?? 'Announcement created successfully';
      return right(successMessage);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* DELETE → Remove announcement
  @override
  Future<Either<String, String>> deleteAnnouncement({
    required String announcementId,
  }) async {
    try {
      final response = await api.delete(
        EndPoints.deleteAnnouncement(announcementId),
      );

      // Update local cache manually
      final currentCache = localDataSource.getCachedAnnouncements();
      final updatedCache = currentCache
          .where((ann) => ann.id != announcementId)
          .toList();
      await localDataSource.cacheAnnouncements(updatedCache);

      // We return the success message from the API response
      return right(response[ApiKeys.message] ?? 'Deleted Successfully');
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* PATCH → Update announcement partially
  @override
  Future<Either<String, AnnouncementModel>> updateAnnouncement({
    required String announcementId,
    required UpdateAnnouncementRequestModel request,
  }) async {
    try {
      final response = await api.patch(
        EndPoints.updateAnnouncement(announcementId),
        data: request.toJson(),
      );

      final updatedAnnouncement = AnnouncementModel.fromJson(
        response[ApiKeys.data],
      );

      // Update local cache manually
      final currentCache = localDataSource.getCachedAnnouncements();
      final updatedCache = currentCache.map((ann) {
        if (ann.id == announcementId) {
          return updatedAnnouncement;
        }
        return ann;
      }).toList();
      await localDataSource.cacheAnnouncements(updatedCache);

      return right(updatedAnnouncement);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* POST → Add comment to announcement
  @override
  Future<Either<String, Unit>> addComment({
    required String announcementId,
    required CommentRequestModel request,
  }) async {
    try {
      await api.post(
        EndPoints.addComment(announcementId),
        data: request.toJson(),
      );

      return right(unit);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* PATCH → Update existing comment
  @override
  Future<Either<String, CommentDetails>> updateComment({
    required String commentId,
    required CommentRequestModel request,
  }) async {
    try {
      final response = await api.patch(
        EndPoints.commentById(commentId),
        data: request.toJson(),
      );

      final updatedComment = CommentDetails.fromJson(response[ApiKeys.data]);
      return right(updatedComment);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* DELETE → Remove a comment
  @override
  Future<Either<String, Unit>> deleteComment({
    required String commentId,
  }) async {
    try {
      await api.delete(
        EndPoints.commentById(commentId),
      );

      return right(unit);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }
}
