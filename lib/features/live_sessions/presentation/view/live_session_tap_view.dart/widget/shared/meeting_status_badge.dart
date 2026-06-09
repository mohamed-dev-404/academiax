import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/live_sessions/data/model/helper/meeting_state_enum.dart';

class MeetingStatusBadge extends StatelessWidget {
  final MeetingStateEnum state;
  final String formattedTime;

  const MeetingStatusBadge({
    super.key,
    required this.state,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String text, Color color) = switch (state) {
      MeetingStateEnum.ongoing => (
        Icons.live_tv_rounded,
        'Live Now',
        StatusColors.green,
      ),
      MeetingStateEnum.scheduled => (
        Icons.event_note_rounded,
        'Scheduled: $formattedTime',
        StatusColors.blue,
      ),
      MeetingStateEnum.ended => (
        Icons.videocam_off_rounded,
        'Meeting Ended',
        AppColors.whiteDarkActive,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: AppStyles.mobileBodyXsmallMd.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
