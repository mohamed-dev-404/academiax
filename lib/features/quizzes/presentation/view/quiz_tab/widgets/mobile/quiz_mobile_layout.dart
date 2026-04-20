import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/mobile/mobile_quiz_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/get_all_quizes_cubit/get_all_quizes_cubit.dart';

class QuizMobileLayout extends StatelessWidget {
  final String courseId;
  final List<QuizModel> quizzes;
  final UserRole userRole;

  const QuizMobileLayout({
    super.key,
    required this.courseId,
    required this.quizzes,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInstructor = userRole == UserRole.instructor;

    // Calculate how many fixed items we have before the actual quiz list
    // Title is always there (1), Add button only for instructor (+1)
    final int headerCount = isInstructor ? 2 : 1;

    return ListView.builder(
      // Total items = Headers + Quizzes (or 1 for Lottie if empty)
      itemCount: headerCount + (quizzes.isEmpty ? 1 : quizzes.length),
      itemBuilder: (context, index) {
        // 1. Render Title Section
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Quizzes',
              style: AppStyles.mobileTitleSmallSb.copyWith(fontSize: 24),
            ),
          );
        }

        // 2. Render Instructor Add Button (Only if index 1 and user is instructor)
        if (isInstructor && index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AddNewCard(
              title: 'Create Quiz',
              isMobile: true,
              onTap: () => _navigateToCreateQuiz(context),
            ),
          );
        }

        // 3. Handle Empty State or Quiz List
        // Calculate the actual quiz index by subtracting headers
        final int quizIndex = index - headerCount;

        if (quizzes.isEmpty) {
          return Center(
            child: Lottie.asset(AppLottie.empty),
          );
        }

        // 4. Render Quiz Cards
        final quiz = quizzes[quizIndex];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: MobileQuizCard(
            quizModel: quiz,
            onTap: () => _handleQuizNavigation(context, quiz),
          ),
        );
      },
    );
  }

  /// Navigation logic to create quiz screen
  void _navigateToCreateQuiz(BuildContext context) {
    context
        .push(
          RoutesName.createQuiz,
          extra: CreateQuizFormArgs(
            courseId: courseId,
            isEditMode: false,
          ),
        )
        .then((_) {
          if (context.mounted) {
            context.read<GetAllQuizesCubit>().getCourseQuizzes(
              courseId: courseId,
            );
          }
        });
  }

  /// Centralized navigation logic based on business rules
  void _handleQuizNavigation(BuildContext context, QuizModel quiz) {
    final bool isInstructor = userRole == UserRole.instructor;
    final bool canEnter = quiz.state != QuizState.closed || isInstructor;

    if (canEnter) {
      context
          .push(
            RoutesName.quizDetails,
            extra: {
              'quizId': quiz.id.toString(),
              'courseId': courseId,
            },
          )
          .then((_) {
            if (context.mounted) {
              context.read<GetAllQuizesCubit>().getCourseQuizzes(
                courseId: courseId,
              );
            }
          });
    } else if (quiz.state == QuizState.upcoming) {
      AppToast.warning(
        context,
        'This quiz starts on ${quiz.formattedStartTime}',
      );
    }
  }
}
