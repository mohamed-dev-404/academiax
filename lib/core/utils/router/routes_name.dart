class RoutesName {
  RoutesName._();

  //? Auth routes
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String activateAccount = '/auth/activateAccount';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  //? Home & Profile routes
  static const String courses = '/courses';
  static const String createCourse = '/createCourse';
  static const String profile = '/profile';

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
}
