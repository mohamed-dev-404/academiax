import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/mobile/components/manage_questions_body.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

/// The primary adaptive layout shell for managing quiz questions.
///
/// Wraps the stateful mutable representation of questions and handles Route
/// argument extraction and initial loading states.
class ManageQuestionsMobileLayout extends StatelessWidget {
  final ManageQuestionsArgs args;
  const ManageQuestionsMobileLayout({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageQuizCubit, ManageQuizState>(
      buildWhen: (prev, curr) {
        return curr is ManageQuizInitial ||
            curr is ManageQuizLoading ||
            curr is ManageQuizQuestionsLoaded;
      },
      builder: (context, state) {
        if (state is ManageQuizLoading) {
          return const Scaffold(
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        if (state is ManageQuizQuestionsLoaded) {
          return ManageQuestionsBody(
            initialQuestions: state.questions,
            args: args,
          );
        }

        return const Scaffold(
          body: Center(child: AppAnimatedLoadingIndicator()),
        );
      },
    );
  }
}
