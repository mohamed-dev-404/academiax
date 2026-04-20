import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';

class QuizTimerHeaderWeb extends StatelessWidget {
  final List questions;
  final String quizTitle;

  const QuizTimerHeaderWeb({
    super.key,
    required this.questions,
    required this.quizTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeQuizCubit, TakeQuizState>(
      buildWhen: (prev, curr) {
        if (prev is! TakeQuizInProgress || curr is! TakeQuizInProgress) {
          return true;
        }
        return prev.remainingSeconds != curr.remainingSeconds ||
            prev.currentQuestionIndex != curr.currentQuestionIndex;
      },
      builder: (context, state) {
        if (state is! TakeQuizInProgress) return const SizedBox.shrink();

        final currentQuestionNum = state.currentQuestionIndex + 1;
        final totalQuestions = state.questions.length;
        final progress = state.timeProgress;
        final pointsOfQuestion =
            state.questions[state.currentQuestionIndex].points;

        final minutes = (state.remainingSeconds ~/ 60).toString().padLeft(
          2,
          '0',
        );
        final seconds = (state.remainingSeconds % 60).toString().padLeft(
          2,
          '0',
        );

        final timerColor = state.isLast10Seconds
            ? AppColors.red
            : (state.isLast15Seconds
                  ? StatusColors.orangeDark
                  : AppColors.green);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    quizTitle,
                    style: AppStyles.mobileTitleMediumSb.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.secondaryLightActive,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$pointsOfQuestion Points',
                        style: AppStyles.mobileBodySmallSb.copyWith(
                          color: AppColors.secondaryDark,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentQuestionNum.toString().padLeft(2, '0')} of ${totalQuestions.toString().padLeft(2, '0')}',
                  style: AppStyles.mobileBodyMediumRg.copyWith(
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: timerColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$minutes:$seconds',
                        style: AppStyles.mobileBodySmallSb.copyWith(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: state.isLast10Seconds
                    ? AppColors.redLightActive
                    : (state.isLast15Seconds
                          ? StatusColors.orangeLight
                          : AppColors.greenLightActive),
                valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                minHeight: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
