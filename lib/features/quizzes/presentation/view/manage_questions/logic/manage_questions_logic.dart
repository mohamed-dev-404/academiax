import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';

/// A logic mixin that encapsulates all list manipulation for managing questions.
///
/// This separates the "How" (logic) from the "What" (UI), keeping the main
/// body file clean and maintainable.
mixin ManageQuestionsLogic<T extends StatefulWidget> on State<T> {
  late List<EditableQuestionModel> questions;

  /// Initializes the local questions list from the widget's initial data.
  void initQuestions(List<EditableQuestionModel> initialQuestions) {
    questions = List.from(initialQuestions);
  }

  /// Appends a new question of the specified [questionType] to the list.
  void addQuestion(String questionType) {
    setState(() {
      final EditableQuestionModel newQuestion;
      switch (questionType) {
        case ApiValues.written:
          newQuestion = EditableQuestionModel.written();
          break;
        case ApiValues.mcq:
          newQuestion = EditableQuestionModel.mcq();
          break;
        case ApiValues.trueFalse:
          newQuestion = EditableQuestionModel.trueFalse();
          break;
        default:
          return;
      }
      questions = [...questions, newQuestion];
    });
  }

  /// Removes a question locally by its [localId].
  void removeQuestion(String localId) {
    setState(() {
      questions = questions.where((q) => q.localId != localId).toList();
    });
  }

  /// Updates specific fields of a question identified by [localId].
  void updateQuestionField(
    String localId, {
    String? text,
    int? timeLimit,
    num? points,
  }) {
    // We create a completely new list instance to ensure Flutter detects the state change.
    final updatedQuestions = questions.map((q) {
      if (q.localId != localId) return q;
      // copyWith returns a fresh instance with updated values.
      return q.copyWith(
        text: text,
        timeLimit: timeLimit,
        points: points,
      );
    }).toList();

    setState(() {
      questions = updatedQuestions;
    });
  }

  /// Changes the type of an existing question and resets its options accordingly.
  void changeQuestionType(String localId, String newType) {
    setState(() {
      questions = questions.map((q) {
        if (q.localId != localId) return q;
        if (q.questionType == newType) return q;

        List<EditableOptionModel> newOptions;
        switch (newType) {
          case ApiValues.written:
            newOptions = [];
            break;
          case ApiValues.mcq:
            newOptions = [
              EditableOptionModel.empty(),
              EditableOptionModel.empty(),
            ];
            break;
          case ApiValues.trueFalse:
            newOptions = [
              EditableOptionModel.trueFalse(label: 'True', isCorrect: true),
              EditableOptionModel.trueFalse(label: 'False', isCorrect: false),
            ];
            break;
          default:
            newOptions = [];
        }

        return q.copyWith(questionType: newType, options: newOptions);
      }).toList();
    });
  }

  /// Adds a new empty option to an MCQ question.
  void addOption(String questionLocalId) {
    setState(() {
      questions = questions.map((q) {
        if (q.localId != questionLocalId || !q.isMcq) return q;
        return q.copyWith(
          options: [...q.options, EditableOptionModel.empty()],
        );
      }).toList();
    });
  }

  /// Removes an option from a question by its IDs.
  void removeOption(String questionLocalId, String optionLocalId) {
    setState(() {
      questions = questions.map((q) {
        if (q.localId != questionLocalId) return q;
        if (q.options.length <= 2) return q;
        return q.copyWith(
          options: q.options.where((o) => o.localId != optionLocalId).toList(),
        );
      }).toList();
    });
  }

  /// Updates the text of a specific option.
  void updateOptionText(
    String questionLocalId,
    String optionLocalId,
    String text,
  ) {
    setState(() {
      questions = questions.map((q) {
        if (q.localId != questionLocalId) return q;
        return q.copyWith(
          options: q.options.map((o) {
            if (o.localId != optionLocalId) return o;
            return o.copyWith(text: text);
          }).toList(),
        );
      }).toList();
    });
  }

  /// Toggles which option is marked as correct (exclusive for MCQ/TrueFalse).
  void toggleCorrectOption(String questionLocalId, String optionLocalId) {
    setState(() {
      questions = questions.map((q) {
        if (q.localId != questionLocalId) return q;
        return q.copyWith(
          options: q.options.map((o) {
            if (o.localId == optionLocalId) return o.copyWith(isCorrect: true);
            return o.copyWith(isCorrect: false);
          }).toList(),
        );
      }).toList();
    });
  }
}
