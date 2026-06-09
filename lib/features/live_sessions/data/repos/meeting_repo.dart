import 'package:dartz/dartz.dart';
import 'package:sams_app/features/live_sessions/data/model/create_meeting_request.dart';

import '../model/meeting_model.dart';

abstract class MeetingRepo {
  //* Fetch all meetings for a specific course
  Future<Either<String, List<MeetingModel>>> fetchCourseMeetings({
    required String courseId,
  });

  //* Create a new meeting (Instructor only)
  Future<Either<String, Unit>> createMeeting({
    required String courseId,
    required CreateMeetingRequest request,
  });

  //* Join a meeting and get Agora token
  Future<Either<String, String>> joinMeeting({
    required String meetingId,
  });

  //* End an ongoing meeting (Instructor only)
  Future<Either<String, Unit>> endMeeting({
    required String meetingId,
  });

  //! Delete a meeting permanently
  Future<Either<String, Unit>> deleteMeeting({
    required String meetingId,
  });
}
