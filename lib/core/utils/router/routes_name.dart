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
  static const String announcementDetails = 'announcementDetails';

  //?auth routes
  //login
  static const String login = '/login';
  //sign up
  static const String signUp = '/signUp';
  static const String activateAccount = '/auth/activateAccount';
  // Password Reset Flow Paths
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
}
