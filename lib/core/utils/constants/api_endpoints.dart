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

  //? --- Quizzes --- ;

  //* Discovery Flow (Student/General)
  static String getCourseQuizzes(String courseId) => 'courses/$courseId/quizzes';
  static String getQuizDetails(String quizId) => 'quizzes/$quizId';
  static String getQuizQuestions(String quizId) => 'quizzes/$quizId/questions';
  
  //* Student Flow
  static String submitQuiz(String quizId) => 'quizzes/$quizId/submit';
  
  //* Instructor Flow - Quiz CRUD
  static String createQuiz(String courseId) => 'instructor/courses/$courseId/quizzes';
  static String updateQuiz(String quizId) => 'instructor/quizzes/$quizId';
  static String deleteQuiz(String quizId) => 'instructor/quizzes/$quizId';
  static String toggleQuizPublished(String quizId) => 'instructor/quizzes/$quizId/toggle-published';
  
  //* Instructor Flow - Questions CRUD
  static String createQuestion(String quizId) => 'instructor/quizzes/$quizId/questions';
  static String updateQuestion(String questionId) => 'instructor/questions/$questionId';
  static String deleteQuestion(String questionId) => 'instructor/questions/$questionId';

  //* Instructor Flow - Submissions & Grading
  static String getQuizSubmissions(String quizId) => 'instructor/quizzes/$quizId/submissions';
  static String getSubmissionDetails(String submissionId) => 'instructor/submissions/$submissionId';
  static String gradeQuestion(String submissionId, String questionId) => 'instructor/submissions/$submissionId/questions/$questionId';

  //* --- Classworks CRUD --- ;
  static String getAvailableClassworks(String courseId) => 'instructor/courses/$courseId/classworks';
  static String addNewClasswork(String courseId) => 'instructor/courses/$courseId/classworks';
}
