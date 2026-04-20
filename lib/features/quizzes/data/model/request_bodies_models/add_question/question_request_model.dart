import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/add_question/create_option_model.dart';

class QuestionRequestModel {
  final String text;
  final String questionType;
  final int timeLimit;
  final num points;
  final List<CreateOptionModel>? options; // Null for WRITTEN type

  const QuestionRequestModel({
    required this.text,
    required this.questionType,
    required this.timeLimit,
    required this.points,
    this.options,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      ApiKeys.text: text,
      ApiKeys.questionType: questionType,
      ApiKeys.timeLimit: timeLimit,
      ApiKeys.points: points,
    };

    // Only include options if it's not a Written question
    if (options != null && questionType != ApiValues.written) {
      data[ApiKeys.options] = options!
          .map((eachOption) => eachOption.toJson())
          .toList();
    }

    return data;
  }
}
