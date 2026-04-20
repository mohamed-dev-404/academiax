import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/option_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';

class ChoiceQuestionModel extends QuestionModel {
  final List<OptionModel> options;

  const ChoiceQuestionModel({
    required super.id,
    required super.text,
    required super.questionType,
    required super.timeLimit,
    required super.points,
    required this.options,
  });

  factory ChoiceQuestionModel.fromJson(Map<String, dynamic> json) {
    return ChoiceQuestionModel(
      id: json[ApiKeys.id] ?? '',
      text: json[ApiKeys.text] ?? '',
      questionType: json[ApiKeys.questionType] ?? '', // either mcq or trueFalse
      timeLimit: json[ApiKeys.timeLimit] ?? 0, // in minutes
      points: json[ApiKeys.points] ?? 0,
      options:
          (json[ApiKeys.options] as List<dynamic>?)
              ?.map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      ApiKeys.options: options.map((e) => e.toJson()).toList(),
    };
  }
}
