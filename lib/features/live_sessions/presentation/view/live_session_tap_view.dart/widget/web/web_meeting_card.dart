import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/live_sessions/data/model/meeting_model.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/delete_session_dialog.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_action_buttons.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_card_image.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_card_style.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_status_badge.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/meeting_trailing_icon.dart';

class WebMeetingCard extends StatefulWidget {
  final MeetingModel meeting;
  final VoidCallback onJoin;
  final VoidCallback? onEnd;
  final VoidCallback onDelete;
  final bool isInstructor;

  const WebMeetingCard({
    super.key,
    required this.meeting,
    required this.onJoin,
    this.onEnd,
    required this.onDelete,
    required this.isInstructor,
  });

  @override
  State<WebMeetingCard> createState() => _WebMeetingCardState();
}

class _WebMeetingCardState extends State<WebMeetingCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final style = MeetingCardStyle.fromState(widget.meeting.meetingState);
    final bool isEnded = widget.meeting.isEnded;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: isEnded ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isEnded ? null : widget.onJoin,
        child: Container(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovered
                  ? style.titleColor.withValues(alpha: 0.3)
                  : style.borderColor,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isInstructor)
                      IconButton(
                        onPressed: () => DeleteSessionDialog.show(
                          context,
                          onConfirm: widget.onDelete,
                        ),
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    if (widget.isInstructor) const SizedBox(width: 8),
                    MeetingTrailingIcon(
                      state: widget.meeting.meetingState,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.sp,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        transform: Matrix4.identity()
                          // ignore: deprecated_member_use
                          ..translate(
                            0.0,
                            isEnded
                                ? 0.0
                                : isHovered
                                ? -5.0
                                : 0.0,
                          ),
                        child: MeetingCardImage(
                          state: widget.meeting.meetingState,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.meeting.channelName,
                      style: AppStyles.mobileTitleSmallSb.copyWith(
                        fontSize: 18,
                        color: style.titleColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: MeetingStatusBadge(
                        state: widget.meeting.meetingState,
                        formattedTime: widget.meeting.formattedStartTime,
                      ),
                    ),
                    if (isEnded) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Duration: ${widget.meeting.duration} Seconds',
                        textAlign: TextAlign.center,
                        style: AppStyles.mobileBodyXsmallMd.copyWith(
                          color: style.descriptionColor,
                        ),
                      ),
                    ],
                    if (widget.meeting.isOngoing) ...[
                      const SizedBox(height: 16),
                      MeetingActionButtons(
                        onJoin: widget.onJoin,
                        onEnd: widget.onEnd,
                        isInstructor: widget.isInstructor,
                        primaryColor: style.titleColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
