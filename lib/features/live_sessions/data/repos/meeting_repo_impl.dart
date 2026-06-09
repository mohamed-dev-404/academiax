import 'package:dartz/dartz.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/cache/secure_storage.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/constants/app_constants.dart';
import 'package:sams_app/core/utils/constants/cache_keys.dart';
import 'package:sams_app/features/live_sessions/data/model/create_meeting_request.dart';

import '../model/meeting_model.dart';
import './meeting_repo.dart';

class MeetingRepoImpl implements MeetingRepo {
  final ApiConsumer api;

  MeetingRepoImpl({required this.api});

  @override
  Future<Either<String, List<MeetingModel>>> fetchCourseMeetings({
    required String courseId,
  }) async {
    try {
      final response = await api.get(EndPoints.getCourseMeetings(courseId));

      final List meetingsData = response[ApiKeys.data] ?? [];
      final meetings = meetingsData
          .map((e) => MeetingModel.fromJson(e))
          .toList();

      return Right(meetings);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> createMeeting({
    required String courseId,
    required CreateMeetingRequest request,
  }) async {
    try {
      await api.post(
        EndPoints.createMeeting(courseId),
        data: request.toJson(),
      );

      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> joinMeeting({
    required String meetingId,
  }) async {
    final String? accessToken = await SecureStorageService.instance
        .getAccessToken();

    final name = GetStorageHelper.read<String>(CacheKeys.name);

    try {
      final String url =
          '${AppConstants.zegoBaseUrl}?meetingId=$meetingId&token=$accessToken&name=$name';

      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! deleteMeeting and endMeeting
  @override
  Future<Either<String, Unit>> endMeeting({
    required String meetingId,
  }) async {
    try {
      await api.patch(EndPoints.endMeeting(meetingId));
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteMeeting({
    required String meetingId,
  }) async {
    try {
      await api.delete(EndPoints.deleteMeeting(meetingId));
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
