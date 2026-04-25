class RoutesName {
  RoutesName._();

  //? home routes
  static const String courses = '/courses';
  static const String createCourse = '/createCourse';

//? profile routes
  static const String profile = '/profile';

//? course details routes
  static const String materials = 'materials';
  static const String assignments = 'assignments';
  static const String announcements = 'announcements';
  static const String grades = 'grades';
  static const String quizzes = 'quizzes';
  static const String liveSessions = 'liveSessions';
  static const String courseCode = 'courseCode';
  static const String membersList = 'membersList';

  //? announcement sub-routes
  static const String announcementDetails = '/announcementDetails';
  static const String addAnnouncement = '/addAnnouncement';


  //?auth routes
  //login
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String activateAccount = '/auth/activateAccount';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';


  //? Course details (tabs are widgets — NOT routes)
  static const String courseDetails = '/courseDetails';

  //? Quiz standalone routes — all flat, all at root level
  //  extra for each route is documented below:
  //  quizDetails      → { quizId: String }
  //  createQuiz       → { courseId: String }
  //  manageQuestions  → { quizId: String }
  //  takeQuiz         → { quizId: String, quizTitle: String }
  //  submissionsList  → { quizId: String }
  //  gradeSubmission  → { submissionId: String }
  static const String quizDetails = '/quizDetails';
  static const String createQuiz = '/createQuiz';
  static const String manageQuestions = '/manageQuestions';
  static const String takeQuiz = '/takeQuiz';
  static const String submissionsList = '/submissionsList';
  static const String gradeSubmission = '/gradeSubmission';

  //? Material routes
  static const String manageMaterial = '/manageMaterial';
  static const String materialDetails = '/materialDetails';

   //? Assignment details (tabs are widgets — NOT routes)
  static const String assignmentDetails = '/assignmentDetails';
  static const String createAssignment = '/createAssignment';
  static const String assignmentSubmission = '/assignmentSubmission';
  static const String studentProfile = '/studentProfile';
}
