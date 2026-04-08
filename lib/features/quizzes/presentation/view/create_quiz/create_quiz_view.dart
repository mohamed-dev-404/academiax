import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/mobile/create_quiz_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/web/create_quiz_web_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

import 'package:sams_app/features/quizzes/presentation/view/quiz_form/quiz_form_args.dart';

/// Adaptive shell for the Create Quiz flow.
///
/// NOTE: The router creates [CreateQuizView] directly via both `createQuiz`
/// and `quizForm` routes using [QuizFormArgs].
class CreateQuizView extends StatelessWidget {
  final QuizFormArgs args;

  const CreateQuizView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageQuizCubit, ManageQuizState>(
      listener: (context, state) {
        // TODO: Handle ManageQuizFailure (show snackbar) and
        //       ManageQuizSuccess (pop/navigate to quiz details)
      },
      builder: (context, state) {
        return AdaptiveLayout(
          mobileLayout: (context) => CreateQuizMobileLayout(args: args),
          webLayout: (context) => const CreateQuizWebLayout(),
        );
      },
    );
  }
}
