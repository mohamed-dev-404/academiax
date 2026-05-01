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
  static const String profilePic = 'users/profile-picture';

  //? --- Quizzes --- ;

  //* Discovery Flow (Student/General)
  static String getCourseQuizzes(String courseId) =>
      'courses/$courseId/quizzes';
  static String getQuizDetails(String quizId) => 'quizzes/$quizId';
  static String getQuizQuestions(String quizId) => 'quizzes/$quizId/questions';

  //* Student Flow
  static String submitQuiz(String quizId) => 'quizzes/$quizId/submit';

  //* Instructor Flow - Quiz CRUD
  static String createQuiz(String courseId) =>
      'instructor/courses/$courseId/quizzes';
  static String updateQuiz(String quizId) => 'instructor/quizzes/$quizId';
  static String deleteQuiz(String quizId) => 'instructor/quizzes/$quizId';
  static String toggleQuizPublished(String quizId) =>
      'instructor/quizzes/$quizId/toggle-published';

  //* Instructor Flow - Questions CRUD
  static String createQuestion(String quizId) =>
      'instructor/quizzes/$quizId/questions';
  static String updateQuestion(String questionId) =>
      'instructor/questions/$questionId';
  static String deleteQuestion(String questionId) =>
      'instructor/questions/$questionId';

  //* Instructor Flow - Submissions & Grading
  static String getQuizSubmissions(String quizId) =>
      'instructor/quizzes/$quizId/submissions';
  static String getSubmissionDetails(String submissionId) =>
      'instructor/submissions/$submissionId';
  static String gradeQuestion(String submissionId, String questionId) =>
      'instructor/submissions/$submissionId/questions/$questionId';

  //* --- Classworks CRUD --- ;
  static String getAvailableClassworks(String courseId) =>
      'instructor/courses/$courseId/classworks';
  static String addNewClasswork(String courseId) =>
      'instructor/courses/$courseId/classworks';

  //? --- Materials --- ;
  static String getMaterials(String courseId) => 'courses/$courseId/materials';
  static String materialDetails(String materialId) => 'materials/$materialId';
  static String createMaterialUploadUrls(String courseId) =>
      'courses/$courseId/context/presigned-urls';
  static String addMaterial(String courseId) =>
      'instructor/courses/$courseId/materials';
  static String deleteMaterial(String materialId) =>
      'instructor/materials/$materialId';
  static String deleteMaterialItem(String materialId) =>
      'instructor/materials/$materialId/items';
  static String addMaterialItems(String materialId) =>
      'instructor/materials/$materialId/items';
  static String updateMaterialData(String materialId) =>
      'instructor/materials/$materialId';

  //? --- Announcements --- ;
  static String getCourseAnnouncements(String courseId) =>
      'courses/$courseId/announcements';
  static String getAnnouncementDetails(String announcementId) =>
      'announcements/$announcementId';

  //* Instructor Announcement Operations

  /// Endpoint to create a new announcement for a specific course.
  /// Needs [courseId] to be passed in the URL.
  static String createAnnouncement(String courseId) =>
      'instructor/courses/$courseId/announcements';

  /// Endpoint to update an existing announcement.
  /// Needs [announcementId] to be passed in the URL.
  static String updateAnnouncement(String announcementId) =>
      'instructor/announcements/$announcementId';

  /// Endpoint to delete an existing announcement.
  /// Needs [announcementId] to be passed in the URL.
  static String deleteAnnouncement(String announcementId) =>
      'instructor/announcements/$announcementId';

  //* --- Comments Operations --- ;

  /// Endpoint to add a comment to a specific announcement.
  static String addComment(String announcementId) =>
      'announcements/$announcementId/comments';

  /// Endpoint to update or delete a specific comment.
  static String commentById(String commentId) => 'comments/$commentId';

  //? --- Assignments --- ;

  //* S3 Helpers
  static String createAssignmentUploadUrls(String courseId) =>
      'courses/$courseId/context/presigned-urls';

  //* Management (Instructor)
  static String addAssignment(String courseId) =>
      'instructor/courses/$courseId/assignments';
  static String deleteAssignment(String assignmentId) =>
      'instructor/assignments/$assignmentId';
  static String deleteAssignmentItem(String assignmentId) =>
      'instructor/assignments/$assignmentId/items';
  static String getCourseAssignments(String courseId) =>
      'courses/$courseId/assignments';
  static String getAssignmentDetails(String assignmentId) =>
      'assignments/$assignmentId';
  static String addAssignmentItems(String assignmentId) =>
      'instructor/assignments/$assignmentId/items';

// //? --- Instructor Submissions Endpoints --- ;

/// 1. Fetches all student submissions for a specific assignment.
static String getSubmissions(String assignmentId) => 
    'instructor/assignments/$assignmentId/submissions';

/// 2. Retrieves detailed information for a single assignment submission.
static String getAssignmentSubmissionDetails(String submissionId) => 
    'instructor/assignment-submissions/$submissionId';

/// 3. Updates or assigns a grade to a specific student submission.
static String gradeSubmission(String submissionId) => 
    'instructor/assignment-submissions/$submissionId/grade';

/// 4. Approves all submissions for a given assignment in a single action.
static String approveSubmissions(String assignmentId) => 
    'instructor/assignments/$assignmentId/submissions/approve-all';

  static String submitAssignment(String assignmentId) =>
      'assignments/$assignmentId/submissions';
      
  static String unsubmitAssignment(String submissionId) =>
      'assignment-submissions/$submissionId';
}
