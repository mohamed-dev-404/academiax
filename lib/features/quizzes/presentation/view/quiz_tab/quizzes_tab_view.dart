import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/mobile/quiz_mobile_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/web/quiz_web_layout.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/get_all_quizes_cubit/get_all_quizes_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/get_all_quizes_cubit/get_all_quizes_state.dart';

class QuizzesTabView extends StatelessWidget {
  final String courseId;
  const QuizzesTabView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllQuizesCubit, GetAllQuizesState>(
      builder: (context, state) {
        if (state is GetAllQuizesLoading) {
          return const Center(child: AppAnimatedLoadingIndicator());
        }

        if (state is GetAllQuizesSuccess) {
          return AdaptiveLayout(
            mobileLayout: (context) => QuizMobileLayout(
              courseId: courseId,
              quizzes: state.quizzes,
              userRole: CurrentRole.role,
            ),
            webLayout: (context) => QuizsWebLayout(
              courseId: courseId,
              quizzes: state.quizzes,
              userRole: CurrentRole.role,
            ),
          );
        }

        if (state is GetAllQuizesFailure) {
          return Center(child: Text(state.errorMessage));
        }

        // Initial State
        return const SizedBox();
      },
    );
  }
}
