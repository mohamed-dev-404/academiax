import 'package:sams_app/core/utils/constants/api_keys.dart';

enum SubmissionAction {
  approved,
  rejected,
}

extension SubmissionActionExtension on SubmissionAction {
  String toJson() {
    switch (this) {
      case SubmissionAction.approved:
        return ApiKeys.approves;
      case SubmissionAction.rejected:
        return ApiKeys.rejected;
    }
  }
}