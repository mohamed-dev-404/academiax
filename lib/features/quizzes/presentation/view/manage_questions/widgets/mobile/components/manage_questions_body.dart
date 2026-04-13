import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/logic/manage_questions_logic.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/mobile/components/add_question_bottom_sheet.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/delete_question_dialog.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/mobile/components/manage_questions_bottom_bar.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/empty_state_widget.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/mode_configuration_header.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

/// The central stateful body for managing questions locally in the UI.
///
/// Forks the [initialQuestions] from the API into a mutable local state.
/// Manipulates them via internal callbacks, then securely delegates the
/// finalized list to [ManageQuestionsBottomBar].
class ManageQuestionsBody extends StatefulWidget {
  final List<EditableQuestionModel> initialQuestions;
  final ManageQuestionsArgs args;

  const ManageQuestionsBody({
    super.key,
    required this.initialQuestions,
    required this.args,
  });

  @override
  State<ManageQuestionsBody> createState() => _ManageQuestionsBodyState();
}

class _ManageQuestionsBodyState extends State<ManageQuestionsBody>
    with ManageQuestionsLogic<ManageQuestionsBody> {
  @override
  void initState() {
    super.initState();
    initQuestions(widget.initialQuestions);
  }

  // ──────────── Build Methods ────────────

  @override
  Widget build(BuildContext context) {
    final mode = widget.args.mode;
    final isReadOnly = mode == QuizMode.view;
    final canAddNew = mode == QuizMode.draft || mode == QuizMode.edit;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          bottomNavigationBar: isReadOnly
              ? null
              : ManageQuestionsBottomBar(
                  mode: mode,
                  questions: questions,
                ),
          floatingActionButton: canAddNew && questions.isNotEmpty
              ? _buildFab(context)
              : null,
          body: Column(
            children: [
              ModeConfigurationHeader(
                mode: mode,
                questionCount: questions.length,
                quizTitle: widget.args.quizTitle,
              ),
              Expanded(
                child: questions.isEmpty
                    ? EmptyStateWidget(
                        onAddFirst: canAddNew
                            ? () => AddQuestionBottomSheet.show(
                                context,
                                onAdd: addQuestion,
                              )
                            : null,
                      )
                    : _buildQuestionsList(),
              ),
            ],
          ),
        ),

        // Handle Action Loading Overlay locally so we don't lose widget state
        BlocBuilder<ManageQuizCubit, ManageQuizState>(
          builder: (context, state) {
            if (state is ManageQuizActionLoading) {
              return Container(
                color: Colors.white.withAlpha(120),
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

  Widget _buildQuestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return QuestionCard(
          key: ValueKey(question.localId),
          question: question,
          mode: widget.args.mode,
          index: index,
          onRemove: widget.args.mode == QuizMode.edit && !question.isNew
              ? (localId) => _confirmDeleteServer(localId)
              : removeQuestion,
          onUpdateField: updateQuestionField,
          onChangeType: changeQuestionType,
          onAddOption: addOption,
          onRemoveOption: removeOption,
          onUpdateOptionText: updateOptionText,
          onToggleCorrectOption: toggleCorrectOption,
        );
      },
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => AddQuestionBottomSheet.show(context, onAdd: addQuestion),
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
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
            questions,
          );
        }
      },
    );
  }
}
