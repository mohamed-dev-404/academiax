import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/choice_question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/written_question_model.dart';

abstract class QuestionModel {
  final String id;
  final String text;
  final String questionType;
  final int timeLimit;
  final num points;

  const QuestionModel({
    required this.id,
    required this.text,
    required this.questionType,
    required this.timeLimit,
    required this.points,
  });

  //* The factory discriminator (bases on questionType)
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final type = json[ApiKeys.questionType] as String?;

    if (type == ApiValues.written) {
      return WrittenQuestionModel.fromJson(json);
    } else if (type == ApiValues.mcq || type == ApiValues.trueFalse) {
      return ChoiceQuestionModel.fromJson(json);
    } else {
      throw Exception('Unknown question type: $type');
    }
  }

  Map<String, dynamic> toJson();
}
