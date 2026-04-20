import 'package:intl/intl.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/helper/parse_date_helper.dart';

//! --- Quiz States ---

enum QuizState {
  //! Student States
  upcoming, //upcoming quiz: startTime > now
  available, //available quiz: startTime < now && endTime > now
  closed, //closed quiz: endTime < now
  //! Instructor States
  draft, //draft quiz: isPublished = false && startTime > now
  scheduled, //scheduled quiz: isPublished = true && startTime > now
  onGoing, //on going quiz: startTime < now && endTime > now
  completed, //completed quiz: isPublished = true && endTime < now
  lockedDraft, //locked draft quiz: isPublished = false && endTime < now
}

//! --- Quiz Model ---

class QuizModel {
  final String id;
  final String title;
  final String? description; // Nullable to handle the empty object quirk safely
  final DateTime startTime;
  final DateTime endTime;
  final int totalTime;
  final num totalScore;
  final int numberOfQuestions;
  final bool isPublished;

  const QuizModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.totalScore,
    required this.numberOfQuestions,
    required this.isPublished,
  });

  //! --- Display Getters (using intl package) ---

  /// Returns format like: "13 Mar, 09:19 AM"
  String get formattedStartTime =>
      DateFormat('dd MMM, hh:mm a').format(startTime);
  String get formattedEndTime => DateFormat('dd MMM, hh:mm a').format(endTime);

  //! --- Logic Getters ---

  bool get isStarted => DateTime.now().isAfter(startTime);
  bool get isEnded => DateTime.now().isAfter(endTime);
  bool get isAvailable => !isEnded && isStarted;

  QuizState get state {
    final now = DateTime.now();
    if (CurrentRole.role == UserRole.student) {
      //* student states
      if (now.isBefore(startTime)) return QuizState.upcoming;
      if (now.isAfter(endTime)) return QuizState.closed;
      return QuizState.available;
    } else {
      //* instructor states
      if (now.isBefore(startTime) && !isPublished) return QuizState.draft;
      if (now.isBefore(startTime) && isPublished) return QuizState.scheduled;
      if (now.isAfter(endTime) && isPublished) return QuizState.completed;
      if (now.isAfter(startTime) && !isPublished) return QuizState.lockedDraft;
      return QuizState.onGoing;
    }
  }

  //! --- from json ---

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    // Safely handle the backend quirk where description might be {} instead of a String
    String? parsedDescription;
    if (json[ApiKeys.description] is String) {
      parsedDescription = json[ApiKeys.description];
    }
    return QuizModel(
      id: json[ApiKeys.id] ?? '',
      title: json[ApiKeys.title] ?? '',
      description: parsedDescription,
      startTime: parseDate(json[ApiKeys.startTime]),
      endTime: parseDate(json[ApiKeys.endTime]),
      totalTime: json[ApiKeys.totalTime] ?? 0,
      totalScore: json[ApiKeys.totalScore] ?? 0,
      numberOfQuestions: json[ApiKeys.numberOfQuestions] ?? 0,
      isPublished: json[ApiKeys.isPublished] ?? true,
    );
  }

  //! --- to json ---

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.description:
          description ??
          {}, // Send back empty object if null, to match backend DTO
      ApiKeys.startTime: startTime.toIso8601String(),
      ApiKeys.endTime: endTime.toIso8601String(),
      ApiKeys.totalTime: totalTime,
      ApiKeys.totalScore: totalScore,
      ApiKeys.numberOfQuestions: numberOfQuestions,
      ApiKeys.isPublished: isPublished,
    };
  }
}
