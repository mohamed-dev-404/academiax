import 'package:dartz/dartz.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/create_quiz_request_body.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/submit_quiz/quiz_answer_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

abstract class QuizRepository {
  // ! --- Discovery Flow ---
  Future<Either<String, List<QuizModel>>> getQuizzesForCourse(String courseId);
  Future<Either<String, QuizModel>> getQuizDetails(String quizId);
  Future<Either<String, List<QuestionModel>>> getQuizQuestions(String quizId);

  // --- Instructor Flow: Quiz CRUD ---
  Future<Either<String, void>> createQuiz(
    String courseId,
    CreateQuizRequestBody data,
  );
  Future<Either<String, void>> updateQuiz(
    String quizId,
    CreateQuizRequestBody data,
  );
  Future<Either<String, Unit>> deleteQuiz(String quizId);
  Future<Either<String, String>> toggleQuizPublished(String quizId);

  // --- Instructor Flow: Questions CRUD ---
  Future<Either<String, Unit>> addQuestion(
    String quizId,
    Map<String, dynamic> data,
  );
  Future<Either<String, Unit>> updateQuestion(
    String questionId,
    Map<String, dynamic> data,
  );
  Future<Either<String, Unit>> deleteQuestion(String questionId);

  // ! --- Student Flow: Taking Quizzes ---
  Future<Either<String, String>> submitQuiz(
    String quizId,
    List<QuizAnswerModel> answers,
  );

  // ! --- Instructor Flow: Grading ---
  Future<Either<String, List<SubmissionModel>>> getAllSubmissions(
    String quizId,
  );
  Future<Either<String, List<StudentSubmissionModel>>> getStudentSubmission(
    String submissionId,
  );
  Future<Either<String, String>> gradeWrittenQuestion(
    String submissionId,
    String questionId,
    num grade,
  );

  // ! --- Instructor Flow: create/get Classworks ---
  // /api/v1/instructor/courses/{courseId}/classworks
  Future<Either<String, List<ClassworkItemModel>>> getAvailableClassworks(
    String courseId,
  );

  // /api/v1/instructor/courses/{courseId}/classworks
  Future<Either<String, String>> addNewClasswork(
    String courseId,
    String classworkName,
    num points,
  );
}
