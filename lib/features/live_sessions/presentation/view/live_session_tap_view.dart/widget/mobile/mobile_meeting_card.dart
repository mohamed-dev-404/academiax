import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/live_sessions/data/model/meeting_model.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/delete_session_dialog.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_action_buttons.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_card_style.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_status_badge.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_trailing_icon.dart';

class MobileMeetingCard extends StatelessWidget {
  final MeetingModel meeting;
  final VoidCallback onJoin;
  final VoidCallback? onEnd;
  final VoidCallback onDelete;
  final bool isInstructor;

  const MobileMeetingCard({
    super.key,
    required this.meeting,
    required this.onJoin,
    this.onEnd,
    required this.onDelete,
    required this.isInstructor,
  });

  @override
  Widget build(BuildContext context) {
    final style = MeetingCardStyle.fromState(meeting.meetingState);
    final bool canJoin = meeting.isOngoing;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: style.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: style.borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.channelName,
                        style: AppStyles.web16Semibold.copyWith(
                          color: style.titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      MeetingStatusBadge(
                        state: meeting.meetingState,
                        formattedTime: meeting.formattedStartTime,
                      ),
                    ],
                  ),
                ),
                if (isInstructor)
                  IconButton(
                    onPressed: () => DeleteSessionDialog.show(
                      context,
                      onConfirm: onDelete,
                    ),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (isInstructor) const SizedBox(width: 8),
                MeetingTrailingIcon(state: meeting.meetingState),
              ],
            ),
            if (canJoin) ...[
              const SizedBox(height: 16),
              MeetingActionButtons(
                onJoin: onJoin,
                onEnd: onEnd,
                isInstructor: isInstructor,
                primaryColor: style.titleColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
