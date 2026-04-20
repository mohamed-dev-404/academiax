import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/widgets/mobile/take_quiz_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/widgets/web/take_quiz_web_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';

class TakeQuizView extends StatelessWidget {
  final String quizTitle;
  const TakeQuizView({super.key, required this.quizTitle});

  @override
  Widget build(BuildContext context) {
    // * BlocListener only — no builder needed here because AdaptiveLayout
    // * always renders the same two widgets regardless of state.
    // * Each layout manages its own BlocBuilders internally.
    return BlocListener<TakeQuizCubit, TakeQuizState>(
      listener: (context, state) {
        // Show the error toast whenever a submit attempt fails.
        // Defined once here so mobile and web layouts don't repeat this logic.
        if (state is TakeQuizInProgress && state.submitErrorMessage != null) {
          AppToast.error(
            context,
            state.submitErrorMessage ?? 'Unexpected error, please try again.',
          );
        }
      },
      child: AdaptiveLayout(
        mobileLayout: (context) => TakeQuizMobileLayout(quizTitle: quizTitle),
        webLayout: (context) => TakeQuizWebLayout(quizTitle: quizTitle),
      ),
    );
  }
}
