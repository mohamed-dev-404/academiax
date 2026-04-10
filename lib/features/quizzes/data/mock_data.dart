import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/choice_question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/written_question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/option_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';

//! get available Classworks (used by QuizFormScreen to populate the dropdown)
// SOURCE: GET /api/v1/instructor/courses/:courseId/classworks
// This will be replaced by a real API call through a Cubit once the endpoint is wired.
const List<ClassworkItemModel> mockClassworkItems = [
  ClassworkItemModel(
    id: '69bfb6e0236365ff8ee35687',
    name: 'Midterm',
    points: 15,
    isVisible: true,
  ),
  ClassworkItemModel(
    id: '69bfb6e0236365ff8ee3568a',
    name: 'Quiz 3',
    points: 5,
    isVisible: true,
  ),
  ClassworkItemModel(
    id: '69bfb6e0236365ff8ee3568b',
    name: 'Quiz 4',
    points: 5,
    isVisible: true,
  ),
];

//! get all Quizes
List<QuizModel> mockQuizzes = [
  // 1. UPCOMING QUIZ (Starts in 2 days)
  QuizModel(
    id: 'q_upcoming_02',
    title: 'Quiz 2: Advanced Queries',
    description:
        'Chapter 3: Joins, subqueries, and indexing strategie Joins, subqueries, and indexing strategies.s.',
    startTime: DateTime.now().add(const Duration(days: 2)),
    endTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
    totalTime: 45,
    totalScore: 50,
    numberOfQuestions: 15,
    isPublished: true,
  ),

  // 2. ACTIVE QUIZ (Started 2 hours ago, ends tomorrow)
  QuizModel(
    id: 'q_active_01',
    title: 'Quiz 1: Database Fundamentals',
    description: 'Chapter 2: Relational models, normalization, and SQL basics.',
    startTime: DateTime.now().subtract(const Duration(hours: 2)),
    endTime: DateTime.now().add(const Duration(hours: 24)),
    totalTime: 60,
    totalScore: 100,
    numberOfQuestions: 20,
    isPublished: true,
  ),

  QuizModel(
    id: 'q_edge_04',
    title: 'Pop Quiz: ER Diagrams',
    description: null, // Testing your null safety!
    startTime: DateTime.now().subtract(const Duration(minutes: 30)),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    totalTime: 15,
    totalScore: 10,
    numberOfQuestions: 5,
    isPublished: true,
  ),

  // 3. ENDED QUIZ (Ended yesterday)
  QuizModel(
    id: 'q_ended_03',
    title: 'Quiz 0: Intro to Systems',
    description: 'Chapter 1: Overview of database management systems.',
    startTime: DateTime.now().subtract(const Duration(days: 2)),
    endTime: DateTime.now().subtract(const Duration(days: 1)),
    totalTime: 30,
    totalScore: 20,
    numberOfQuestions: 10,
    isPublished: true,
  ),
];

//! get Questions
final List<QuestionModel> mockQuestions = [
  // 1. MCQ Question (Matching your screenshot)
  const ChoiceQuestionModel(
    id: 'q1',
    text: 'What is the full form of DBMS?',
    questionType: 'mcq',
    timeLimit: 60,
    points: 1,
    options: [
      OptionModel(id: 'o1', text: 'Data of Binary Management System.'),
      OptionModel(id: 'o2', text: 'Database Management System.'),
      OptionModel(id: 'o3', text: 'Database Management Service.'),
      OptionModel(id: 'o4', text: 'Data Backup Management System.'),
    ],
  ),

  // 2. True/False Question
  const ChoiceQuestionModel(
    id: 'q2',
    text: 'SQL stands for Structured Question Language.',
    questionType: 'trueFalse',
    timeLimit: 30,
    points: 1,
    options: [
      OptionModel(id: 't1', text: 'True'),
      OptionModel(id: 't2', text: 'False'),
    ],
  ),

  // 3. Written Question
  const WrittenQuestionModel(
    id: 'q3',
    text: 'Explain the concept of First Normal Form (1NF) in your own words.',
    questionType: 'written',
    timeLimit: 120,
    points: 5,
  ),
];

//! get All Submission

final List<SubmissionModel> mockSubmissions = [
  SubmissionModel(
    id: 'sub_1',
    quizId: 'q1',
    academicId: '20113564',
    studentName: 'Monica Maged Awad',
    score: 10,
    totalPoints: 15,
    submittedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    isGraded: true,
  ),
  SubmissionModel(
    id: 'sub_2',
    quizId: 'q1',
    academicId: '20113565',
    studentName: 'Yomna Abdelmegeed',
    score: 8,
    totalPoints: 15,
    submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
    isGraded: true,
  ),
  SubmissionModel(
    id: 'sub_3',
    quizId: 'q1',
    academicId: '20113566',
    studentName: 'Mohamed Ibrahim',
    score: 0,
    totalPoints: 15,
    submittedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    isGraded: false,
  ),

  // AllSubmissionModel(
  //   id: 'sub_4',
  //   quizId: 'q1',
  //   academicId: '20113567',
  //   studentName: 'Ahmed Hassan',
  //   score: 9,
  //   submittedAt: DateTime.now().subtract(const Duration(minutes: 30)),
  //   isGraded: true,
  // ),

  // AllSubmissionModel(
  //   id: 'sub_5',
  //   quizId: 'q1',
  //   academicId: '20113568',
  //   studentName: 'Sara Ali',
  //   score: 6,
  //   submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
  //   isGraded: true,
  // ),

  // AllSubmissionModel(
  //   id: 'sub_6',
  //   quizId: 'q1',
  //   academicId: '20113569',
  //   studentName: 'Omar Khaled',
  //   score: 0,
  //   submittedAt: DateTime.now().subtract(const Duration(minutes: 10)),
  //   isGraded: false,
  // ),

  // AllSubmissionModel(
  //   id: 'sub_7',
  //   quizId: 'q1',
  //   academicId: '20113570',
  //   studentName: 'Nour ElDin',
  //   score: 10,
  //   submittedAt: DateTime.now().subtract(const Duration(hours: 3)),
  //   isGraded: true,
  // ),

  // AllSubmissionModel(
  //   id: 'sub_8',
  //   quizId: 'q1',
  //   academicId: '20113571',
  //   studentName: 'Laila Mahmoud',
  //   score: 3,
  //   submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
  //   isGraded: true,
  // ),

  // AllSubmissionModel(
  //   id: 'sub_9',
  //   quizId: 'q1',
  //   academicId: '20113572',
  //   studentName: 'Hassan Tarek',
  //   score: 0,
  //   submittedAt: DateTime.now().subtract(const Duration(seconds: 30)),
  //   isGraded: false,
  // ),

  // AllSubmissionModel(
  //   id: 'sub_10',
  //   quizId: 'q1',
  //   academicId: '20113573',
  //   studentName: 'Abdelrahman Mohamed Abdelaziz',
  //   score: 7,
  //   submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
  //   isGraded: true,
  // ),
];

//! get Submission Details
final List<StudentSubmissionModel> mockSubmissionDetails = [
  const StudentSubmissionModel(
    id: '69c00b00c02d96d94370043b',
    text: "Which HTTP status code means 'Unauthorized'?",
    questionType: 'WRITTEN',
    timeLimit: 60,
    points: 4,
    writtenAnswer: '404 Not Found',
    earnedPoints: 0,
    isCorrect: null,
    isGraded: false,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d94370043c',
    text: "Explain the purpose of Middleware in an Express.js application.",
    questionType: 'WRITTEN',
    timeLimit: 500,
    points: 10,
    writtenAnswer: "I don't know",
    earnedPoints: 0,
    isCorrect: null,
    isGraded: false,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d94370043d',
    text: "What is the difference between final and const in Dart?",
    questionType: 'WRITTEN',
    timeLimit: 60,
    points: 4,
    writtenAnswer: null, // Empty answer test
    earnedPoints: 0,
    isCorrect: false,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d94370043e',
    text: "Which HTTP status code means 'Unauthorized'?",
    questionType: 'MCQ',
    timeLimit: 20,
    points: 2,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d94370043f',
        text: '401',
        isCorrect: true,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700440',
        text: '403',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700441',
        text: '404',
        isCorrect: false,
        isSelected: true,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700442',
        text: '400',
        isCorrect: false,
        isSelected: false,
      ),
    ],
    selectedOptionId: 'f3',
    earnedPoints: 0,
    isCorrect: false,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d943700443',
    text: "Flutter uses Skia as its primary 2D rendering engine.",
    questionType: 'TRUE_FALSE',
    timeLimit: 30,
    points: 5,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d943700444',
        text: 'True',
        isCorrect: false,
        isSelected: true,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700445',
        text: 'False',
        isCorrect: true,
        isSelected: false,
      ),
    ],
    selectedOptionId: 'tf1',
    earnedPoints: 5,
    isCorrect: true,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d943700446',
    text:
        'Which HTTP status code is used when a resource has been successfully created?',
    questionType: 'MCQ',
    timeLimit: 30,
    points: 2,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d943700447',
        text: '200',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700448',
        text: '201',
        isCorrect: true,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700449',
        text: '204',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370044a',
        text: '400',
        isCorrect: false,
        isSelected: true,
      ),
    ],
    selectedOptionId: 'c4',
    earnedPoints: 0,
    isCorrect: false,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d94370044b',
    text:
        'Which status code indicates that the server is refusing to fulfill the request because the user lacks necessary permissions (Forbidden)?',
    questionType: 'MCQ',
    timeLimit: 50,
    points: 2,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d94370044c',
        text: '401',
        isCorrect: false,
        isSelected: true,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370044d',
        text: '403',
        isCorrect: true,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370044e',
        text: '404',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370044f',
        text: '500',
        isCorrect: false,
        isSelected: false,
      ),
    ],
    selectedOptionId: 'tf3',
    earnedPoints: 2,
    isCorrect: true,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d943700450',
    text: 'What does a 500 Internal Server Error signify?',
    questionType: 'MCQ',
    timeLimit: 30,
    points: 2,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d943700451',
        text: 'The client sent a bad request.',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700452',
        text: 'The server encountered an unexpected condition.',
        isCorrect: true,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700453',
        text: 'The resource was not found.',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700454',
        text: 'The request timed out.',
        isCorrect: false,
        isSelected: true,
      ),
    ],
    selectedOptionId: 's4',
    earnedPoints: 0,
    isCorrect: false,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d943700455',
    text:
        'In a Clean Architecture approach, which layer should contain the Data Transfer Objects (DTOs)?',
    questionType: 'MCQ',
    timeLimit: 30,
    points: 2,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d943700456',
        text: 'Domain Layer',
        isCorrect: false,
        isSelected: true,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700457',
        text: 'Presentation Layer',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700458',
        text: 'Data Layer',
        isCorrect: true,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d943700459',
        text: 'Core Layer',
        isCorrect: false,
        isSelected: false,
      ),
    ],
    selectedOptionId: 'tf5',
    earnedPoints: 2,
    isCorrect: true,
    isGraded: true,
  ),
  const StudentSubmissionModel(
    id: '69c00b00c02d96d94370045a',
    text:
        'Which principle of SOLID states that a class should have only one reason to change?',
    questionType: 'MCQ',
    timeLimit: 30,
    points: 2,
    options: [
      AnswerOptionModel(
        id: '69c00b00c02d96d94370045b',
        text: 'Open-Closed Principle',
        isCorrect: false,
        isSelected: true,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370045c',
        text: 'Liskov Substitution Principle',
        isCorrect: false,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370045d',
        text: 'Single Responsibility Principle',
        isCorrect: true,
        isSelected: false,
      ),
      AnswerOptionModel(
        id: '69c00b00c02d96d94370045e',
        text: 'Dependency Inversion Principle',
        isCorrect: false,
        isSelected: false,
      ),
    ],
    selectedOptionId: 'so1',
    earnedPoints: 0,
    isCorrect: false,
    isGraded: true,
  ),
];
