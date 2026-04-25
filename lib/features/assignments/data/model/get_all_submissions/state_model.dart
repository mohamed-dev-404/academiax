import 'package:sams_app/core/utils/constants/api_keys.dart';

class StateModel {
  final int submitted;
  final int marked;
  final int unmarked;

  StateModel({
    required this.submitted,
    required this.marked,
    required this.unmarked,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      submitted: json[ApiKeys.submitted],
      marked: json[ApiKeys.marked],
      unmarked: json[ApiKeys.unmarked],
    );
  }
}