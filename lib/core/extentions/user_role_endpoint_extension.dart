import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';

extension UserRoleEndpointExtension on UserRole {
  String get myCoursesEndpoint {
    switch (this) {
      case UserRole.instructor:
        return EndPoints.getMyCreatedCourses;
      case UserRole.student:
        return EndPoints.getMyJoinedCourses;
    }
  }

  String removeCourseEndpoint(String courseId) {
    switch (this) {
      case UserRole.instructor:
        return EndPoints.deleteCourse(courseId);
      case UserRole.student:
        return EndPoints.unenrollCourse(courseId);
    }
  }
}
