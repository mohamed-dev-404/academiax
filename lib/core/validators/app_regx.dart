abstract class AppRegex {
  // Email Validation
  static bool isEmailValid(String email) {
    return RegExp(r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.[a-zA-Z]+)?$').hasMatch(email);
  }

  //academic email validation
  static bool isAcademicEmailValid(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@o6u\.edu\.eg$').hasMatch(email);
  }

  // Strong Password Validation (8+ chars, at least 1 lowercase letter, at least 1 uppercase letter, 1 digit, at least 1 special character)
  static bool isPasswordValid(String password) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(password);
  }

  // Egyptian Phone Number Validation (010, 011, 012, 015)
  static bool isValidEgyptianPhoneNumber(String number) {
    final regex = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    return regex.hasMatch(number);
  }

  // Global Phone Number Validation
  static bool isGlobalPhoneNumberValid(String phoneNumber) {
    return RegExp(
      r'^\d{7,15}$',
    ).hasMatch(phoneNumber.replaceAll(RegExp(r'\D'), ''));
  }

  // Username Validation (Letters only, min 3 characters)
  static bool isUserNameValid(String name) {
    return RegExp(r'^[a-zA-Z\s]{3,}$').hasMatch(name);
  }

  // Arabic Name Validation (Only Arabic letters)
  static bool isArabicNameValid(String name) {
    return RegExp(r'^[\u0621-\u064A\s]{2,}$').hasMatch(name);
  }

  // Numbers Only
  static bool isNumeric(String input) {
    return RegExp(r'^\d+$').hasMatch(input);
  }

  // Decimal Numbers (int or double)
  static bool isDecimal(String input) {
    return RegExp(r'^\d+(\.\d+)?$').hasMatch(input);
  }
}

///  Examples:
///
/// print(AppRegex.isEmailValid("test@email.com")); // ✅ true
/// print(AppRegex.isPasswordValid("abc12345")); // ✅ true
/// print(AppRegex.isValidEgyptianPhoneNumber("01000000000")); // ✅ true
/// print(AppRegex.isUserNameValid("test")); // ✅ true
/// print(AppRegex.isArabicNameValid("عربي)); // ✅ true
/// print(AppRegex.isNumeric("12345")); // ✅ true
///
