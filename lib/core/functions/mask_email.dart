import 'package:sams_app/core/validators/app_validators.dart';

String maskEmail(String email) {
  if (AppValidators.validateAcademicEmail(email) != null) return email;

  final parts = email.split('@');
  String username = parts[0];
  String domain = parts[1];

  // If username is too short (e.g., 'ad@sams.com'), just return as is or minimal mask
  if (username.length <= 3) {
    return '${username[0]}**@$domain';
  }

  // Get first two: 'ad'
  String firstTwo = username.substring(0, 2);
  // Get last one: 'm'
  String lastOne = username.substring(username.length - 1);

  // Combine: 'ad' + '******' + 'm' + '@' + 'sams.com'
  return '$firstTwo******$lastOne@$domain';
}
