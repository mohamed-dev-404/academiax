import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/live_sessions/data/model/helper/meeting_state_enum.dart';

class MeetingCardStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color descriptionColor;

  const MeetingCardStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  factory MeetingCardStyle.fromState(MeetingStateEnum state) {
    return switch (state) {
      MeetingStateEnum.ongoing => MeetingCardStyle(
        backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
        borderColor: StatusColors.green.withValues(alpha: 0.3),
        titleColor: StatusColors.greenDark,
        descriptionColor: StatusColors.greenDark.withValues(alpha: 0.8),
      ),
      MeetingStateEnum.scheduled => MeetingCardStyle(
        backgroundColor: StatusColors.blueLight,
        borderColor: StatusColors.blue.withValues(alpha: 0.3),
        titleColor: StatusColors.blueDark,
        descriptionColor: AppColors.primaryDark,
      ),
      MeetingStateEnum.ended => const MeetingCardStyle(
        backgroundColor: AppColors.white,
        borderColor: AppColors.whiteHover,
        titleColor: AppColors.whiteDarkActive,
        descriptionColor: AppColors.whiteDark,
      ),
    };
  }
}
