import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/web/components/web_manage_questions_body.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

class ManageQuestionsWebLayout extends StatelessWidget {
  final ManageQuestionsArgs args;
  const ManageQuestionsWebLayout({super.key, required this.args});

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
            backgroundColor: Color(0xFFF4F6F9),
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        if (state is ManageQuizQuestionsLoaded) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F9),
            body: WebManageQuestionsBody(
              initialQuestions: state.questions,
              args: args,
            ),
          );
        }

        return const Scaffold(
          backgroundColor: Color(0xFFF4F6F9),
          body: Center(child: AppAnimatedLoadingIndicator()),
        );
      },
    );
  }
}
