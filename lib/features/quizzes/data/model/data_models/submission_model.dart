import 'package:intl/intl.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/helper/parse_date_helper.dart';

enum SubmissionStatus { marked, unmarked }

class SubmissionModel {
  final String id;
  final String quizId;
  final String academicId;
  final String studentName;
  final int score;
  final int totalPoints;
  final DateTime submittedAt;
  final bool isGraded;

  const SubmissionModel({
    required this.id,
    required this.quizId,
    required this.totalPoints,
    required this.academicId,
    required this.studentName,
    required this.score,
    required this.submittedAt,
    required this.isGraded,
  });

  //! --- Display Getters (for UI) ---

  /// Formats the date to match UI (e.g., "12:59 PM")
  String get formattedTime => DateFormat('hh:mm a').format(submittedAt);

  /// Automatically returns the correct score string (e.g., "10" or "-")
  /// In the UI, you can just do: "${submission.displayScore}/10"
  String get displayScore => isGraded ? score.toString() : '-';

  //! --- Logic Getters ---

  /// Returns the enum state matching your UI summary tabs
  SubmissionStatus get status =>
      isGraded ? SubmissionStatus.marked : SubmissionStatus.unmarked;

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json[ApiKeys.id] ?? '',
      quizId: json[ApiKeys.quizId] ?? '',
      academicId: json[ApiKeys.academicId] ?? '',
      studentName: json[ApiKeys.studentName] ?? 'Unknown Student',
      score: json[ApiKeys.score] ?? 0,
      totalPoints: json[ApiKeys.totalPoints] ?? 0,
      // Safely parse date and convert to local time
      submittedAt: parseDate(json[ApiKeys.submittedAt]),
      isGraded: json[ApiKeys.isGraded] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.quizId: quizId,
      ApiKeys.academicId: academicId,
      ApiKeys.studentName: studentName,
      ApiKeys.score: score,
      ApiKeys.totalPoints: totalPoints,
      ApiKeys.submittedAt: submittedAt.toIso8601String(),
      ApiKeys.isGraded: isGraded,
    };
  }
}
