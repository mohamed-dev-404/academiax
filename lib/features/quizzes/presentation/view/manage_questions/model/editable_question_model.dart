import 'package:uuid/uuid.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/choice_question_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/add_question/question_request_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/add_question/create_option_model.dart';

const _uuid = Uuid();

// ──────────────────────────────────────────────────────────────────────────────
// Editable Option Model (Local UI Model)
// ──────────────────────────────────────────────────────────────────────────────

/// A mutable-friendly option model used exclusively inside the Cubit
/// for local list manipulation. Converted to [CreateOptionModel] at submit time.
class EditableOptionModel {
  final String localId;
  final String text;
  final bool isCorrect;

  const EditableOptionModel({
    required this.localId,
    this.text = '',
    this.isCorrect = false,
  });

  /// Factory for creating a brand-new option with a generated ID.
  factory EditableOptionModel.empty() => EditableOptionModel(
        localId: _uuid.v4(),
      );

  /// Factory for creating a True/False pair.
  factory EditableOptionModel.trueFalse({
    required String label,
    required bool isCorrect,
  }) =>
      EditableOptionModel(
        localId: _uuid.v4(),
        text: label,
        isCorrect: isCorrect,
      );

  EditableOptionModel copyWith({
    String? text,
    bool? isCorrect,
  }) {
    return EditableOptionModel(
      localId: localId,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  /// Converts to the API DTO.
  CreateOptionModel toDto() => CreateOptionModel(
        text: text,
        isCorrect: isCorrect,
      );
}

// ──────────────────────────────────────────────────────────────────────────────
// Editable Question Model (Local UI Model)
// ──────────────────────────────────────────────────────────────────────────────

/// A rich UI model managed by the Cubit. **Not** sent directly to the API.
///
/// Converted to [QuestionRequestModel] / [AddQuestionsRequestBody] only
/// at submission time via [toDto()].
class EditableQuestionModel {
  final String localId;
  final String? serverId;
  final String text;
  final String questionType;
  final int timeLimit;
  final num points;
  final List<EditableOptionModel> options;

  const EditableQuestionModel({
    required this.localId,
    this.serverId,
    this.text = '',
    required this.questionType,
    this.timeLimit = 30,
    this.points = 1,
    this.options = const [],
  });

  // ──────────── Factory Constructors ────────────

  /// Creates a new WRITTEN question.
  factory EditableQuestionModel.written() => EditableQuestionModel(
        localId: _uuid.v4(),
        questionType: ApiValues.written,
      );

  /// Creates a new MCQ question with 2 default empty options.
  factory EditableQuestionModel.mcq() => EditableQuestionModel(
        localId: _uuid.v4(),
        questionType: ApiValues.mcq,
        options: [
          EditableOptionModel.empty(),
          EditableOptionModel.empty(),
        ],
      );

  /// Creates a new TRUE_FALSE question with fixed True/False options.
  factory EditableQuestionModel.trueFalse() => EditableQuestionModel(
        localId: _uuid.v4(),
        questionType: ApiValues.trueFalse,
        options: [
          EditableOptionModel.trueFalse(label: 'True', isCorrect: true),
          EditableOptionModel.trueFalse(label: 'False', isCorrect: false),
        ],
      );

  /// Creates from an API-fetched [QuestionModel] (for edit/view modes).
  factory EditableQuestionModel.fromServer(QuestionModel model) {
    final List<EditableOptionModel> options;

    if (model is ChoiceQuestionModel) {
      options = model.options
          .map((opt) => EditableOptionModel(
                localId: _uuid.v4(),
                text: opt.text,
                isCorrect: opt.isCorrect ?? false,
              ))
          .toList();
    } else {
      options = [];
    }

    return EditableQuestionModel(
      localId: _uuid.v4(),
      serverId: model.id,
      text: model.text,
      questionType: model.questionType,
      timeLimit: model.timeLimit,
      points: model.points,
      options: options,
    );
  }

  // ──────────── Convenience Getters ────────────

  bool get isWritten => questionType == ApiValues.written;
  bool get isMcq => questionType == ApiValues.mcq;
  bool get isTrueFalse => questionType == ApiValues.trueFalse;
  bool get isNew => serverId == null;

  // ──────────── CopyWith ────────────

  EditableQuestionModel copyWith({
    String? text,
    String? questionType,
    int? timeLimit,
    num? points,
    List<EditableOptionModel>? options,
  }) {
    return EditableQuestionModel(
      localId: localId,
      serverId: serverId,
      text: text ?? this.text,
      questionType: questionType ?? this.questionType,
      timeLimit: timeLimit ?? this.timeLimit,
      points: points ?? this.points,
      options: options ?? this.options,
    );
  }

  // ──────────── DTO Mapping ────────────

  /// Converts to the API DTO for submission.
  QuestionRequestModel toDto() {
    return QuestionRequestModel(
      text: text,
      questionType: questionType,
      timeLimit: timeLimit,
      points: points,
      options: isWritten ? null : options.map((o) => o.toDto()).toList(),
    );
  }
}
