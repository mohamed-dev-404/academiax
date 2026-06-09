import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/end_session_dialog.dart';

class MeetingActionButtons extends StatelessWidget {
  final VoidCallback onJoin;
  final VoidCallback? onEnd;
  final bool isInstructor;
  final Color primaryColor;

  const MeetingActionButtons({
    super.key,
    required this.onJoin,
    this.onEnd,
    required this.isInstructor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomAppButton(
            onPressed: onJoin,
            backgroundColor: primaryColor,
            elevation: 0,
            shadowColor: Colors.transparent,
            overlayColor: Colors.white.withAlpha(50),
            borderRadius: 10,
            height: 38,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam_rounded, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Join',
                  style: AppStyles.mobileBodySmallSb.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        if (isInstructor && onEnd != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: CustomAppButton(
              onPressed: () {
                EndSessionDialog.show(context, onConfirm: onEnd!);
              },
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              elevation: 0,
              shadowColor: Colors.transparent,
              overlayColor: Colors.red.withAlpha(30),
              borderRadius: 10,
              height: 38,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stop_rounded, size: 18, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(
                    'End',
                    style: AppStyles.mobileBodySmallSb.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
