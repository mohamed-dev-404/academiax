import 'package:sams_app/core/utils/constants/api_keys.dart';

class StudentInfoModel {
  final String? academicId;
  final String? name;
  final String? profilePic;

  StudentInfoModel({
    this.academicId,
    this.name,
    this.profilePic,
  });

  factory StudentInfoModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return StudentInfoModel(
        academicId: '',
        name: 'Unknown',
        profilePic: '',
      );
    }

    return StudentInfoModel(
      academicId: json[ApiKeys.academicId]?.toString() ?? '',
      name: json[ApiKeys.name]?.toString() ?? 'Unknown',
      profilePic: json[ApiKeys.profilePic]?.toString() ?? '',
    );
  }
}