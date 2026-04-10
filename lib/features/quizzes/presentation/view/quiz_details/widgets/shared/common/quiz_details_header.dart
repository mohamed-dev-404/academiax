import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/logic/instructor_action_handler.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/logic/quiz_action_type.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/widgets/shared/common/quiz_details_state_badge.dart';

class QuizDetailsHeader extends StatelessWidget {
  const QuizDetailsHeader({super.key, required this.quiz});

  final QuizModel quiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuizDetailsStateBadge(
                quizModel: quiz,
              ),

              CurrentRole.role == UserRole.instructor
                  ? IconButton(
                      onPressed: () {
                        InstructorActionHandler.execute(
                          context: context,
                          action: QuizActionType.editQuiz,
                          quiz: quiz,
                        );
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: AppColors.whiteLight,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            quiz.title,
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: AppColors.whiteLight,
            ),
          ),
          if (quiz.description != null) ...[
            const SizedBox(height: 8),
            Text(
              quiz.description!,
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.whiteHover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
