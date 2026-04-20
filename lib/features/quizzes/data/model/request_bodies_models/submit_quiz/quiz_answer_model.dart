import 'package:sams_app/core/utils/constants/api_keys.dart';

class QuizAnswerModel {
  final String questionId;
  final String? selectedOptionId;
  final String? writtenAnswer;

  const QuizAnswerModel({
    required this.questionId,
    this.selectedOptionId,
    this.writtenAnswer,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      ApiKeys.questionId: questionId,
    };

    // Only attach the field if it was provided
    if (selectedOptionId != null) {
      data[ApiKeys.selectedOptionId] = selectedOptionId;
    }

    if (writtenAnswer != null) {
      data[ApiKeys.writtenAnswer] = writtenAnswer;
    }

    return data;
  }
}
