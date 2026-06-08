import 'package:sams_app/core/utils/constants/api_keys.dart';

class GradeRowModel {
  final GradeStudentModel student;
  final Map<String, dynamic> grades;

  GradeRowModel({
    required this.student,
    required this.grades,
  });

  factory GradeRowModel.fromJson(Map<String, dynamic> json) {
    return GradeRowModel(
      student: GradeStudentModel.fromJson(
        json[ApiKeys.student] as Map<String, dynamic>,
      ),
      // Using a Map here because keys like "69bfb6..." are dynamic
      grades: json[ApiKeys.grades] as Map<String, dynamic>,
    );
  }
}

class GradeStudentModel {
  final String academicId;
  final String name;

  GradeStudentModel({required this.academicId, required this.name});

  factory GradeStudentModel.fromJson(Map<String, dynamic> json) {
    return GradeStudentModel(
      academicId: json[ApiKeys.academicId] as String,
      name: json[ApiKeys.name] as String,
    );
  }
}
