import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/mobile/instructor/quiz_details_mobile_instructor_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/mobile/student/quiz_details_mobile_student_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/web/instructor/quiz_details_web_instructor_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/web/student/quiz_details_web_student_layout.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/quiz_details_cubit/quiz_details_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/quiz_details_cubit/quiz_details_state.dart';

class QuizDetailsView extends StatelessWidget {
  final String quizId;
  final String courseId;
  const QuizDetailsView({
    super.key,
    required this.quizId,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    // * fetch quiz details (in build method to ensure re-fetch on rebuild in pop back from submission or qustions view)
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      context.read<QuizDetailsCubit>().getQuizDetails(quizId);
    }

    return BlocConsumer<QuizDetailsCubit, QuizDetailsState>(
      listener: (context, state) {
        if (state is QuizDetailsDeleteSuccess) {
          AppToast.success(context, state.message);
          context.pop(); // Go back to the course screen or previous screen
        } else if (state is QuizDetailsDeleteFailure) {
          AppToast.error(context, state.errorMessage);
        }
      },
      buildWhen: (previous, current) =>
          current is QuizDetailsLoading ||
          current is QuizDetailsSuccess ||
          current is QuizDetailsFailure,
      builder: (context, state) {
        // * handle loading state
        if (state is QuizDetailsLoading) {
          return const Scaffold(
            body: Center(child: AppAnimatedLoadingIndicator()),
          );
        }

        // * handle success state
        if (state is QuizDetailsSuccess) {
          final quiz = state.quiz;

          return AdaptiveLayout(
            mobileLayout: (context) => CurrentRole.role == UserRole.instructor
                ? QuizDetailsMobileInstructorLayout(
                    quiz: quiz,
                    courseId: courseId,
                  )
                : QuizDetailsMobileStudentLayout(
                    quiz: quiz,
                    courseId: courseId,
                  ),
            webLayout: (context) => CurrentRole.role == UserRole.instructor
                ? QuizDetailsWebInstructorLayout(quiz: quiz, courseId: courseId)
                : QuizDetailsWebStudentLayout(
                    quiz: quiz,
                    courseId: courseId,
                  ),
          );
        }

        // * handle failure state
        if (state is QuizDetailsFailure) {
          return Scaffold(body: Center(child: Text(state.errorMessage)));
        }

        return const SizedBox();
      },
    );
  }
}
