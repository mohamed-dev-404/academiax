import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/mobile/create_quiz_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/web/create_quiz_web_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';

import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/safe_pop_function.dart';

/// Adaptive shell for the Create Quiz flow.
///
/// NOTE: The router creates [CreateQuizView] directly via `createQuiz`
/// route using [CreateQuizFormArgs].
class CreateQuizView extends StatelessWidget {
  const CreateQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateQuizCubit, CreateQuizState>(
      listener: (context, state) {
        if (state is CreateQuizSuccess) {
          AppToast.success(context, state.message);
          safePop(context: context);
        } else if (state is CreateQuizFailure) {
          AppToast.error(context, state.message);
        }
      },
      builder: (context, state) {
        return AdaptiveLayout(
          mobileLayout: (context) => const CreateQuizMobileLayout(),
          webLayout: (context) => const CreateQuizWebLayout(),
        );
      },
    );
  }
}
