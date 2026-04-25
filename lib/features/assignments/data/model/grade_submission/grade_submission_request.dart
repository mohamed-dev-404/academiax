import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/grade_submission/submission_action_extention.dart';

class GradeSubmissionRequest {
  final SubmissionAction action;

  GradeSubmissionRequest({required this.action});

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.action: action.toJson(),
    };
  }
}