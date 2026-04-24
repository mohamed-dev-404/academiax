import 'package:intl/intl.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/student_info_model.dart';

class AssSubmissionModel {
  final String id;
  final StudentInfoModel studentInfo;
  final String submittedAt;
  final List<dynamic> submittedItems;
  final bool neededReview;
  final int points;
  final int earnedPoints;

  AssSubmissionModel({
    required this.id,
    required this.studentInfo,
    required this.submittedAt,
    required this.submittedItems,
    required this.neededReview,
    required this.points,
    required this.earnedPoints,
  });

  factory AssSubmissionModel.fromJson(Map<String, dynamic> json) {
    return AssSubmissionModel(
      id: json[ApiKeys.id],
      studentInfo: StudentInfoModel.fromJson(json[ApiKeys.studentInfo]),
      submittedAt: json[ApiKeys.submittedAt],
      submittedItems: json[ApiKeys.submittedItems] ?? [],
      neededReview: json[ApiKeys.neededReview],
      points: json[ApiKeys.points],
      earnedPoints: json[ApiKeys.earnedPoints],
    );
  }
  
  String get formattedTime {
    try {
      final parsedDate =
          DateFormat('M/d/yyyy, h:mm:ss a').parse(submittedAt);
      return DateFormat('hh:mm a').format(parsedDate);
    } catch (e) {
      return submittedAt; // fallback لو حصل error
    }
  }
}
