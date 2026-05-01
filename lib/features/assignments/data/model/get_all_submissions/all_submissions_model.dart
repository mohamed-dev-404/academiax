import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/assignment_submission_model.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/pagination_model.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/state_model.dart';

class AllSubmissionsModel {
  final StateModel stats;
  final List<AssSubmissionModel> submissions;
  final PaginationModel pagination;

  AllSubmissionsModel({
    required this.stats,
    required this.submissions,
    required this.pagination,
  });

  factory AllSubmissionsModel.fromJson(Map<String, dynamic> json) {
    final data = json[ApiKeys.data] ?? {};
    return AllSubmissionsModel(
      stats: StateModel.fromJson(data[ApiKeys.stats] ?? {}),
      submissions: (data[ApiKeys.submissions] as List?)
              ?.map((e) => AssSubmissionModel.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json[ApiKeys.pagination] ?? {}),
    );
  }
}
