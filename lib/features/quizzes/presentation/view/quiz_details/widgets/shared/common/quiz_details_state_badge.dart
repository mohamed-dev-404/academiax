import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';

class QuizDetailsStateBadge extends StatelessWidget {
  const QuizDetailsStateBadge({super.key, required this.quizModel});

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, icon) = _getStateStyle(quizModel.state);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            quizModel.state == QuizState.lockedDraft
                ? 'lOCKED DRAFT'
                : quizModel.state.name.toUpperCase(),
            style: AppStyles.mobileBodyXsmallMd.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //! Helper to determine style based on the exact state meaning
  (Color, Color, IconData) _getStateStyle(QuizState state) {
    switch (state) {
      case QuizState.onGoing:
      case QuizState.available:
        return (
          StatusColors.green,
          AppColors.whiteLight,
          Icons.record_voice_over,
        );
      case QuizState.upcoming:
        return (
          StatusColors.orange,
          AppColors.whiteLight,
          Icons.calendar_today_rounded,
        );
      case QuizState.scheduled:
        return (
          StatusColors.blue,
          AppColors.whiteLight,
          Icons.event_available_rounded,
        );
      case QuizState.completed:
        return (
          AppColors.greenLight,
          StatusColors.greenDark,
          Icons.check_circle_rounded,
        );
      case QuizState.draft:
        return (
          AppColors.whiteHover,
          StatusColors.greyDark,
          Icons.edit_document,
        );
      case QuizState.lockedDraft:
        return (
          AppColors.redLightHover,
          StatusColors.red,
          Icons.lock_clock_rounded,
        );
      default:
        return (
          AppColors.whiteHover,
          StatusColors.greyDark,
          Icons.help_outline,
        );
    }
  }
}
