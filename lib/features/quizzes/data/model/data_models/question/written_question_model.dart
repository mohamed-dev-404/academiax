import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';

class WrittenQuestionModel extends QuestionModel {
  const WrittenQuestionModel({
    required super.id,
    required super.text,
    required super.questionType,
    required super.timeLimit,
    required super.points,
  });

  factory WrittenQuestionModel.fromJson(Map<String, dynamic> json) {
    return WrittenQuestionModel(
      id: json[ApiKeys.id] ?? '',
      text: json[ApiKeys.text] ?? '',
      questionType: json[ApiKeys.questionType] ?? ApiValues.written,
      timeLimit: json[ApiKeys.timeLimit] ?? 0, // in minutes
      points: json[ApiKeys.points] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.text: text,
      ApiKeys.questionType: questionType,
      ApiKeys.timeLimit: timeLimit,
      ApiKeys.points: points,
    };
  }
}
