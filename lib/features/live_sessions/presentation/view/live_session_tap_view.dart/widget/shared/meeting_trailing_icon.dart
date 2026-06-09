import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/live_sessions/data/model/helper/meeting_state_enum.dart';

class MeetingTrailingIcon extends StatelessWidget {
  final MeetingStateEnum state;

  const MeetingTrailingIcon({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _getTrailingIconWidget(),
      ),
    );
  }

  Widget _getTrailingIconWidget() {
    return switch (state) {
      MeetingStateEnum.ongoing => _buildIcon(
        key: 'live',
        icon: Icons.play_arrow_rounded,
        color: AppColors.secondary,
        bgColor: AppColors.secondary.withValues(alpha: 0.1),
        hasBorder: true,
      ),
      MeetingStateEnum.scheduled => _buildIcon(
        key: 'scheduled',
        icon: Icons.calendar_month_rounded,
        color: StatusColors.blue,
        bgColor: StatusColors.blueLight,
        hasBorder: true,
      ),
      MeetingStateEnum.ended => _buildIcon(
        key: 'ended',
        icon: Icons.history_rounded,
        color: AppColors.whiteDark.withValues(alpha: 0.8),
        bgColor: AppColors.whiteHover.withValues(alpha: 0.5),
      ),
    };
  }

  Widget _buildIcon({
    required String key,
    required IconData icon,
    required Color color,
    Color? bgColor,
    bool hasBorder = false,
  }) {
    return Container(
      key: ValueKey(key),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: hasBorder
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
      ),
      child: Center(child: Icon(icon, color: color, size: 16)),
    );
  }
}
