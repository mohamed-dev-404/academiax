import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/logic/manage_questions_logic.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/delete_question_dialog.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/web/components/web_action_sidebar.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/web/components/web_questions_canvas.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

class WebManageQuestionsBody extends StatefulWidget {
  final List<EditableQuestionModel> initialQuestions;
  final ManageQuestionsArgs args;

  const WebManageQuestionsBody({
    super.key,
    required this.initialQuestions,
    required this.args,
  });

  @override
  State<WebManageQuestionsBody> createState() => _WebManageQuestionsBodyState();
}

class _WebManageQuestionsBodyState extends State<WebManageQuestionsBody>
    with ManageQuestionsLogic<WebManageQuestionsBody> {
  @override
  void initState() {
    super.initState();
    initQuestions(widget.initialQuestions);
  }

  void _confirmDeleteServer(String localId) {
    final serverId = questions.firstWhere((q) => q.localId == localId).serverId;

    DeleteQuestionDialog.show(
      context,
      onConfirm: () {
        if (serverId != null) {
          // Optimistic local delete before telling server
          removeQuestion(localId);
          context.read<ManageQuizCubit>().deleteQuestionFromServer(
            serverId,
            questions, // Final synchronized state sent securely to API
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.args.mode;
    final isReadOnly = mode == QuizMode.view;
    final canAddNew = mode == QuizMode.draft || mode == QuizMode.edit;

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Left Action Sidebar (Sticky Controls) ───
            if (!isReadOnly)
              SizedBox(
                width: 320,
                child: WebActionSidebar(
                  args: widget.args,
                  questions: questions,
                  onAddQuestionType: addQuestion,
                ),
              ),

            // ─── Center/Right Canvas (The Viewport) ───
            Expanded(
              child: WebQuestionsCanvas(
                args: widget.args,
                questions: questions,
                canAddNew: canAddNew,
                onAddQuestionBtn: addQuestion,
                onRemove: widget.args.mode == QuizMode.edit
                    ? (localId) {
                        final q = questions.firstWhere(
                          (q) => q.localId == localId,
                        );
                        if (!q.isNew) {
                          _confirmDeleteServer(localId);
                        } else {
                          removeQuestion(localId);
                        }
                      }
                    : removeQuestion,
                onUpdateField: (localId, {text, timeLimit, points}) =>
                    updateQuestionField(
                      localId,
                      text: text,
                      timeLimit: timeLimit,
                      points: points,
                    ),
                onChangeType: changeQuestionType,
                onAddOption: addOption,
                onRemoveOption: removeOption,
                onUpdateOptionText: updateOptionText,
                onToggleCorrectOption: toggleCorrectOption,
              ),
            ),
          ],
        ),

        // Blocking overlay when deleting via API or global saving
        BlocBuilder<ManageQuizCubit, ManageQuizState>(
          builder: (context, state) {
            if (state is ManageQuizActionLoading) {
              return Container(
                color: Colors.white.withAlpha(150),
                child: const Center(
                  child: AppAnimatedLoadingIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
