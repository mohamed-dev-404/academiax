import 'package:sams_app/core/utils/constants/api_keys.dart';

//* Request body for updating the user profile with the new S3 key
class SaveProfilePicRequest {
  final String key;

  SaveProfilePicRequest({required this.key});

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.key: key,
    };
  }
}
