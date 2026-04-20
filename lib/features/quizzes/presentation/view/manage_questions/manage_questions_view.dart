import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/mobile/manage_questions_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/web/manage_questions_web_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';

/// Adaptive shell for the Manage Questions flow.
///
/// Listens for transient success/failure states and shows SnackBars.
/// Delegates rendering to mobile/web layouts.
class ManageQuestionsView extends StatelessWidget {
  final ManageQuestionsArgs args;
  const ManageQuestionsView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageQuizCubit, ManageQuizState>(
      listener: (context, state) {
        if (state is ManageQuizSuccess) {
          AppToast.success(context, state.message);
          context.pop();
        } else if (state is ManageQuizDeleteSuccess) {
          AppToast.success(context, state.message);
        } else if (state is ManageQuizFailure) {
          AppToast.error(context, state.message);
        }
      },
      buildWhen: (prev, curr) =>
          curr is ManageQuizQuestionsLoaded ||
          curr is ManageQuizLoading ||
          curr is ManageQuizInitial,
      builder: (context, state) {
        return AdaptiveLayout(
          mobileLayout: (context) => ManageQuestionsMobileLayout(args: args),
          webLayout: (context) => ManageQuestionsWebLayout(args: args),
        );
      },
    );
  }
}
