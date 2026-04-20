import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/widgets/shared/quiz_question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';
import 'quiz_success_mobile_widget.dart';
import 'quiz_failure_mobile_widget.dart';
import 'quiz_timer_header_mobile.dart';

class TakeQuizMobileLayout extends StatefulWidget {
  final String quizTitle;
  const TakeQuizMobileLayout({super.key, required this.quizTitle});

  @override
  State<TakeQuizMobileLayout> createState() => _TakeQuizMobileLayoutState();
}

class _TakeQuizMobileLayoutState extends State<TakeQuizMobileLayout> {
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
  }

  @override
  void dispose() {
    _writtenAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    // * HEADER: only rebuilds on timer ticks.
                    QuizTimerHeaderMobile(
                      questions: state.questions,
                      quizTitle: widget.quizTitle,
                    ),
                    const SizedBox(height: 24),

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
                              // Using unique key forces a fresh widget if the ID changes,
                              // though our index check above handles the clearing.
                              key: ValueKey(currentQuestion.id),
                              questionIndex:
                                  innerState.currentQuestionIndex + 1,
                              question: currentQuestion,
                              selectedAnswerId: _currentSelectedOption,
                              writtenAnswerController: _writtenAnswerController,
                              onAnswerChanged: (answer) {
                                final cubit = context.read<TakeQuizCubit>();
                                if (currentQuestion.questionType ==
                                    ApiValues.written) {
                                  cubit.saveWrittenAnswer(answer);
                                } else {
                                  // Update local highlight state for MCQ
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

                    const SizedBox(height: 16),
                    _buildNavigationControls(context, state),
                  ],
                ),
              );
            } else if (state is TakeQuizSuccessSubmit) {
              return const QuizSuccessMobileWidget();
            } else if (state is TakeQuizFetchFailure) {
              return QuizFailureMobileWidget(message: state.message);
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: state.isSubmitting && state.isLastQuestion
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(state.isLastQuestion ? 'Submit' : 'Next'),
      ),
    );
  }
}
