import 'package:sams_app/core/utils/constants/api_keys.dart';

//* Core course model used across the home feature
class CourseModel {
  final String id;
  final String name;
  final String academicCourseCode;
  final String instructor;
  final String? courseInvitationCode;

  CourseModel({
    required this.id,
    required this.name,
    required this.academicCourseCode,
    required this.instructor,
    this.courseInvitationCode, // nullable — only available for joinable courses
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: (json[ApiKeys.id] as String?) ?? '',
      name: (json[ApiKeys.name] as String?) ?? '',
      academicCourseCode: (json[ApiKeys.academicCourseCode] as String?) ?? '',
      instructor: (json[ApiKeys.instructor] as String?) ?? '',
      courseInvitationCode: json[ApiKeys.courseInvitationCode] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
      ApiKeys.academicCourseCode: academicCourseCode,
      ApiKeys.instructor: instructor,
      ApiKeys.courseInvitationCode: courseInvitationCode,
    };
  }

  CourseModel copyWith({
    String? id,
    String? name,
    String? academicCourseCode,
    String? instructor,
    String? courseInvitationCode,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      academicCourseCode: academicCourseCode ?? this.academicCourseCode,
      instructor: instructor ?? this.instructor,
      courseInvitationCode: courseInvitationCode ?? this.courseInvitationCode,
    );
  }
}
