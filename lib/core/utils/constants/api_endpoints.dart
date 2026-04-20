class EndPoints {
  EndPoints._();

  //! EndPoints

  //? --- Auth  --- ;
  static String login = 'auth/login';
  static String register = 'auth/register';
  static String refresh = 'auth/refresh';
  static String forgetPassword = 'auth/forgot-password';
  static String verifyOTP = 'auth/verify-otp';
  static String resetPassword = 'auth/reset-password';
  static String resendOTP = 'auth/resend-code';
  static const String logout = 'auth/logout';

  //? --- Home  --- ;
  //* Instructor endpoints
  static const String createCourse = 'instructor/courses';
  static const String getMyCreatedCourses = 'instructor/courses/me';
  static String deleteCourse(String courseId) => 'instructor/courses/$courseId';

  //* Enrollment endpoints
  static const String getMyJoinedCourses = 'enrollments/me';
  static const String joinCourse = 'enrollments';
  static String unenrollCourse(String courseId) =>
      'enrollments/my-courses/$courseId';

  //? --- Profile  --- ;
  static const String getProfile = 'users/profile';
  static const String updateProfile = 'users/profile';
  static const String createUploadUrl = 'users/profile-picture/presigned-url';
  static const String saveProfilePic = 'users/profile-picture';


  //? --- Assignments --- ;
  
  //* S3 Helpers
  static String createAssignmentUploadUrls(String courseId) => 'courses/$courseId/context/presigned-urls';

  //* Management (Instructor)
  static String addAssignment(String courseId) => 'instructor/courses/$courseId/assignments';
  static String deleteAssignment(String assignmentId) => 'instructor/assignments/$assignmentId';
  static String deleteAssignmentItem(String assignmentId) => 'instructor/assignments/$assignmentId/items';
  static String getCourseAssignments(String courseId) => 'courses/$courseId/assignments';
  static String getAssignmentDetails(String assignmentId) => 'assignments/$assignmentId';

  //? --- Submissions --- ;
  static String getSubmissions(String assignmentId) => 'assignments/$assignmentId/submissions';
  static String getSubmissionDetails(String submissionId) => 'assignments/submissions/$submissionId';
  static String gradeSubmission(String submissionId) => 'assignments/submissions/$submissionId/grade';
  static String approveSubmissions(String assignmentId) => 'assignments/$assignmentId/approve-submissions';
      
}
