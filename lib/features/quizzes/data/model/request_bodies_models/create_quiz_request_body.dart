import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/helper/parse_date_helper.dart';

class CreateQuizRequestBody {
  final String? classworkId;
  final String? title;
  final String? description;
  final DateTime? startTime; // Stored as DateTime for UI convenience
  final num? duration;

  const CreateQuizRequestBody({
    this.classworkId,
    this.title,
    this.description,
    this.startTime,
    this.duration,
  });

  //! --- Serialization ---

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (classworkId != null) data[ApiKeys.classworkId] = classworkId;
    if (title != null) data[ApiKeys.title] = title;
    if (description != null) data[ApiKeys.description] = description;

    // Converts DateTime to strict ISO 8601 String for the backend (e.g., "2026-04-19T16:50:37.000Z")
    if (startTime != null) {
      data[ApiKeys.startTime] = formatToUtcIso(startTime!);
    }
    if (duration != null) data[ApiKeys.duration] = duration;

    return data;
  }
}
