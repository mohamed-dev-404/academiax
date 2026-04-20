import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/submit_quiz/quiz_answer_model.dart';

class SubmitQuizRequestBody {
  final List<QuizAnswerModel> answers;

  const SubmitQuizRequestBody({
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.answers: answers.map((answer) => answer.toJson()).toList(),
    };
  }
}
