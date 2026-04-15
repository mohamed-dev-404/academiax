//! --- JSON KEYS (The names that Dio sends and receives) ---

abstract class ApiKeys {
  ApiKeys._();

  //? --- Common Response & General Keys ---
  static const String data = 'data';
  static const String message = 'message';
  static const String id = '_id';
  static const String status = 'status';
  static const String validationErrors = 'validationErrors';
  static const String name = 'name';

  //? User Model Keys
  static const String academicEmail = 'academicEmail';
  static const String academicId = 'academicId';
  static const String password = 'password';
  static const String profilePic = 'profilePic';
  static const String isActive = 'isActive';
  static const String role = 'role';

  //? Pagination Keys
  static const String pagination = 'pagination';
  static const String totalElements = 'totalElements';
  static const String currentPage = 'currentPage';
  static const String size = 'size';
  static const String totalPages = 'totalPages';
  static const String hasNextPage = 'hasNextPage';
  static const String hasPrevPage = 'hasPrevPage';

  //? Fetch Users Params Keys
  static const String page = 'page';
  static const String sortBy = 'sortBy';
  static const String sortOrder = 'sortOrder';
  static const String roleId = 'roleId';
  static const String search = 'search';

  //? --- Image & S3 Upload Keys ---
  static const String originalFileName = 'originalFileName';
  static const String contentType = 'contentType';
  static const String fileSize = 'fileSize';
  static const String key = 'key';
  static const String uploadUrl = 'uploadUrl';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentLengthHeader = 'Content-Length';

  //? --- Course & Home Keys ---
  static const String academicCourseCode = 'academicCourseCode';
  static const String instructor = 'instructor';
  static const String courseInvitationCode = 'courseInvitationCode';
  static const String totalGrades = 'totalGrades';
  static const String finalExam = 'finalExam';
  static const String classwork = 'classwork';
  static const String points = 'points';

  //? Auth Keys
  static const String authorization = 'Authorization';
  static const String user = 'user';
  static const String expiresIn = 'expiresIn';
  static const String refreshToken = 'refreshToken';
  static const String accessToken = 'accessToken';
  static const String resetToken = 'resetToken';
  static const String code = 'code';
  static const String action = 'action';
  static const String newPassword = 'newPassword';
  static const String confirmNewPassword = 'confirmNewPassword';
  static const String roles = 'roles';
  static const String student = 'student';
  static const String confirmPassword = 'confirmPassword';

  //? --- Material Keys ---
  static const String title = 'title';
  static const String description = 'description';
  static const String materialItems = 'materialItems';
  static const String displayUrl = 'displayUrl';
  static const String contentReference = 'contentReference';
  static const String filesMetadata = 'filesMetadata';
  static const String itemKey = 'itemKey';
  static const String context = 'context';
}

//! --- API VALUES (Fixed values that the server expects inside the fields) ---

abstract class ApiValues {
  ApiValues._();

  //?  Sorting Values
  static const String createdAt = 'createdAt';
  static const String desc = 'desc';
  static const String asc = 'asc';

  //? User Status Values
  static const String active = 'active';
  static const String inactive = 'inactive';

  //? Roles
  static const String admin = 'admin';
  static const String instructor = 'instructor';
  static const String student = 'student';

  //? verify oyp actions
  static const String resetPassword = 'RESET_PASSWORD';
  static const String activateAccount = 'ACTIVATE_ACCOUNT';
}
