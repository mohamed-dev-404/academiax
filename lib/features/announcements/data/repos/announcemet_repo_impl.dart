import 'package:dartz/dartz.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/features/announcements/data/data_sources/announcements_local_data_source.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/data/model/announcement_model.dart';
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
}
