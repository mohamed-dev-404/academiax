import 'package:sams_app/core/utils/constants/api_keys.dart';

class StudentGradeModel {
  final String classwork;
  final num? score; // Using num? to handle both int, double, and null values
  final num maxScore; // Using num to be safe with different numeric formats
  final bool isVisible;

  StudentGradeModel({
    required this.classwork,
    this.score,
    required this.maxScore,
    required this.isVisible,
  });

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeModel(
      classwork: json[ApiKeys.classwork] as String,
      score: json[ApiKeys.score] as num?,
      maxScore: json[ApiKeys.maxScore] as num,
      isVisible: json[ApiKeys.isVisible] as bool,
    );
  }

  static String formatScoreValue(num? value) {
    if (value == null) return '-';
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  String get formattedScore => formatScoreValue(score);
  String get formattedMaxScore => formatScoreValue(maxScore);
}

extension StudentGradesListX on Iterable<StudentGradeModel> {
  int get gradedCount => where((g) => g.score != null).length;

  num get totalMaxScore => fold<num>(0, (sum, g) => sum + g.maxScore);

  num get totalScore =>
      where((g) => g.isVisible).fold<num>(0, (sum, g) => sum + (g.score ?? 0));

  num get percentage =>
      totalMaxScore > 0 ? (totalScore / totalMaxScore * 100) : 0;

  String get formattedTotalScore =>
      StudentGradeModel.formatScoreValue(totalScore);

  String get formattedTotalMaxScore =>
      StudentGradeModel.formatScoreValue(totalMaxScore);
}
