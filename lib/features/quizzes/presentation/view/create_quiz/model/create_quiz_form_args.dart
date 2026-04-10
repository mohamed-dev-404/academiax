import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

/// A typed arguments object passed via GoRouter's [extra] parameter
/// when navigating to the [CreateQuizView].
///
/// Using a dedicated args model instead of raw primitives guarantees:
/// - Type safety at the call site.
/// - A single, self-documenting contract for the route.
/// - Easy extensibility (e.g., adding `courseId` later).
class CreateQuizFormArgs {
  /// Always required — needed in both API calls (POST create / PATCH update).
  final String courseId;

  /// Determines the form's mode.
  ///
  /// - `false` → Create mode: empty form, submit calls create-quiz API.
  /// - `true`  → Edit mode: pre-filled form, submit calls update-quiz API.
  final bool isEditMode;

  /// Present **only** when [isEditMode] is `true`.
  ///
  /// Used to pre-populate all controllers and to lock the classwork field.
  final QuizModel? initialData;

  const CreateQuizFormArgs({
    required this.courseId,
    this.isEditMode = false,
    this.initialData,
  }) : assert(
         !isEditMode || initialData != null,
         'initialData must be provided when isEditMode is true',
       );
}
