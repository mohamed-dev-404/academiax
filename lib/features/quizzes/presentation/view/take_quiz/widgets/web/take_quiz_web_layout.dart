import 'package:sams_app/features/quizzes/presentation/view/take_quiz/widgets/web/helper/prevent_default_warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/widgets/shared/quiz_question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';
import 'quiz_success_web_widget.dart';
import 'quiz_failure_web_widget.dart';
import 'quiz_timer_header_web.dart';

class TakeQuizWebLayout extends StatefulWidget {
  final String quizTitle;
  const TakeQuizWebLayout({super.key, required this.quizTitle});

  @override
  State<TakeQuizWebLayout> createState() => _TakeQuizWebLayoutState();
}

class _TakeQuizWebLayoutState extends State<TakeQuizWebLayout> {
  // Tracks the student's currently displayed selection (MCQ/TF only).
  String? _currentSelectedOption;

  // Manages the text input for written questions.
  late final TextEditingController _writtenAnswerController;

  // Tracks the last question index we rendered, so we know when to wipe UI state.
  int _lastRenderedQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _writtenAnswerController = TextEditingController();

    // Prevent Default Warning (web only - safe for mobile import)
    addPreventDefaultWarning();
  }

  @override
  void dispose() {
    removePreventDefaultWarning();
    _writtenAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        // Toast errors are handled once in TakeQuizView's BlocListener.
        // This layout only needs its own BlocBuilders for rendering.
        child: BlocBuilder<TakeQuizCubit, TakeQuizState>(
          builder: (context, state) {
            if (state is TakeQuizLoading) {
              return const Center(child: AppAnimatedLoadingIndicator());
            } else if (state is TakeQuizInProgress) {
              final currentQuestion =
                  state.questions[state.currentQuestionIndex];

              // IMPORTANT: Reset the UI trackers ONLY when the question index actually changes.
              // This is what clears the field for the next question.
              if (_lastRenderedQuestionIndex != state.currentQuestionIndex) {
                _lastRenderedQuestionIndex = state.currentQuestionIndex;
                _currentSelectedOption = null;
                _writtenAnswerController.clear();
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 40.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // * HEADER: rebuilds on every tick.
                        QuizTimerHeaderWeb(
                          questions: state.questions,
                          quizTitle: widget.quizTitle,
                        ),
                        const SizedBox(height: 32),

                        // * QUESTION BODY: only rebuilds on navigation.
                        Expanded(
                          child: BlocBuilder<TakeQuizCubit, TakeQuizState>(
                            buildWhen: (prev, curr) {
                              if (prev is! TakeQuizInProgress ||
                                  curr is! TakeQuizInProgress) {
                                return true;
                              }
                              return prev.currentQuestionIndex !=
                                      curr.currentQuestionIndex ||
                                  prev.isSubmitting != curr.isSubmitting ||
                                  prev.submitErrorMessage !=
                                      curr.submitErrorMessage;
                            },
                            builder: (context, innerState) {
                              if (innerState is! TakeQuizInProgress) {
                                return const SizedBox.shrink();
                              }
                              return SingleChildScrollView(
                                child: QuizQuestionCard(
                                  // Added unique key to ensure widget state reset.
                                  key: ValueKey(currentQuestion.id),
                                  questionIndex:
                                      innerState.currentQuestionIndex + 1,
                                  question: currentQuestion,
                                  selectedAnswerId: _currentSelectedOption,
                                  writtenAnswerController:
                                      _writtenAnswerController,
                                  onAnswerChanged: (answer) {
                                    final cubit = context.read<TakeQuizCubit>();
                                    if (currentQuestion.questionType ==
                                        ApiValues.written) {
                                      cubit.saveWrittenAnswer(answer);
                                    } else {
                                      // Local highlight selection highlight
                                      setState(
                                        () => _currentSelectedOption = answer,
                                      );
                                      cubit.saveSelectedOption(answer);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildNavigationControls(context, state),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is TakeQuizSuccessSubmit) {
              return const QuizSuccessWebWidget();
            } else if (state is TakeQuizFetchFailure) {
              return QuizFailureWebWidget(message: state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildNavigationControls(
    BuildContext context,
    TakeQuizInProgress state,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: state.isSubmitting
            ? null
            : () {
                if (state.isLastQuestion) {
                  context.read<TakeQuizCubit>().submitQuiz();
                } else {
                  context.read<TakeQuizCubit>().goToNextQuestion();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
        ),
        child: state.isSubmitting && state.isLastQuestion
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                state.isLastQuestion ? 'Submit' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
