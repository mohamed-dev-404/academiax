import 'package:sams_app/core/utils/constants/api_keys.dart';

class StudentInfoModel {
  final String academicId;
  final String name;
  final String profilePic;

  StudentInfoModel({
    required this.academicId,
    required this.name,
    required this.profilePic,
  });

  factory StudentInfoModel.fromJson(Map<String, dynamic> json) {
    return StudentInfoModel(
      academicId: json[ApiKeys.academicId],
      name: json[ApiKeys.name],
      profilePic: json[ApiKeys.profilePic],
    );
  }
}