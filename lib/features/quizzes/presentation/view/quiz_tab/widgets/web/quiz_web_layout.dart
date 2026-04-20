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
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/web/web_quiz_card.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/get_all_quizes_cubit/get_all_quizes_cubit.dart';

class QuizsWebLayout extends StatelessWidget {
  final String courseId;
  final List<QuizModel> quizzes;
  final UserRole userRole;

  const QuizsWebLayout({
    super.key,
    required this.courseId,
    required this.quizzes,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInstructor = userRole == UserRole.instructor;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Section
          Text(
            'Quizzes',
            style: AppStyles.mobileTitleSmallSb.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 24),

          // 2. Main Content Logic
          if (quizzes.isEmpty && !isInstructor)
            // Student Empty State: Big centered Lottie
            _buildStudentEmptyState()
          else
            // Instructor (with or without data) OR Student (with data)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _calculateItemCount(isInstructor),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 400 / 440,
              ),
              itemBuilder: (context, index) {
                // Case A: Instructor's first item is always the Add Card
                if (isInstructor && index == 0) {
                  return AddNewCard(
                    title: 'Create Quiz',
                    hight: double.infinity,
                    onTap: () => _navigateToCreateQuiz(context),
                  );
                }

                // Case B: Instructor Empty State - Show Lottie inside the Grid at index 1
                if (isInstructor && quizzes.isEmpty && index == 1) {
                  return _buildInstructorEmptyPlaceholder();
                }

                // Case C: Render actual Quiz Cards
                final int dataIndex = isInstructor ? index - 1 : index;

                // Safety check for data bounds
                if (dataIndex < 0 || dataIndex >= quizzes.length) {
                  return const SizedBox.shrink();
                }

                final quiz = quizzes[dataIndex];
                return WebQuizCard(
                  quizModel: quiz,
                  onTap: () => _handleQuizNavigation(context, quiz),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Calculates the total number of items to show in the Grid
  int _calculateItemCount(bool isInstructor) {
    if (isInstructor) {
      // If empty: 1 (Add Card) + 1 (Empty Lottie) = 2
      // If has data: quizzes.length + 1 (Add Card)
      return quizzes.isEmpty ? 2 : quizzes.length + 1;
    }
    return quizzes.length;
  }

  /// Large centered empty state for students
  Widget _buildStudentEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppLottie.empty, height: 300),
          const SizedBox(height: 16),
          const Text(
            'No quizzes available yet.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Smaller empty state placeholder that fits inside the Grid for instructors
  Widget _buildInstructorEmptyPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(AppLottie.empty, height: 180),
        const SizedBox(height: 12),
        const Text(
          'Your quiz list is empty',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

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

  /// Centralized navigation logic with role-based permissions
  void _handleQuizNavigation(BuildContext context, QuizModel quiz) {
    final bool isInstructor = userRole == UserRole.instructor;

    if (quiz.state != QuizState.closed || isInstructor) {
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
