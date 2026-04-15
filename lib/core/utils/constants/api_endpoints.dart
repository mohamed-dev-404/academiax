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

  //? --- Home/Courses  --- ;
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

  //? --- Materials --- ;
  static String getMaterials(String courseId) => 'courses/$courseId/materials';
  static String materialDetails(String materialId) => 'materials/$materialId';
  static String createMaterialUploadUrls(String courseId) => 'instructor/courses/$courseId/context/presigned-urls';
  static String addMaterial(String courseId) => 'instructor/courses/$courseId/materials';
  static String deleteMaterial(String materialId) => 'instructor/materials/$materialId';
  static String deleteMaterialItem(String materialId) => 'instructor/materials/$materialId/items';
  static String addMaterialItems(String materialId) => 'instructor/materials/$materialId/items';
  static String updateMaterialData(String materialId) => 'instructor/materials/$materialId';
}
