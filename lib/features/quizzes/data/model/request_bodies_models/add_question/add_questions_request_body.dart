import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/add_question/question_request_model.dart';

class AddQuestionsRequestBody {
  final List<QuestionRequestModel> questions;

  const AddQuestionsRequestBody({required this.questions});

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.questions: questions.map((q) => q.toJson()).toList(),
    };
  }
}
