import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/live_sessions/data/model/helper/meeting_state_enum.dart';

class MeetingCardImage extends StatelessWidget {
  final MeetingStateEnum state;

  const MeetingCardImage({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color borderColor) = switch (state) {
      MeetingStateEnum.ongoing => (
        StatusColors.green.withValues(alpha: 0.1),
        StatusColors.green.withValues(alpha: 0.2),
      ),
      MeetingStateEnum.scheduled => (
        StatusColors.blue.withValues(alpha: 0.1),
        StatusColors.blue.withValues(alpha: 0.5),
      ),
      MeetingStateEnum.ended => (
        AppColors.whiteHover.withValues(alpha: 0.5),
        Colors.transparent,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
        border: Border.all(color: borderColor),
      ),
      child: SvgPicture.asset(
        AppImages.imagesMaterialCard,
        height: 55,
        width: 55,
      ),
    );
  }
}
