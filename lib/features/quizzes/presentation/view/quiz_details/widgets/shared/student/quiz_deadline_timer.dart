import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class QuizDeadlineTimer extends StatefulWidget {
  final DateTime endTime;
  const QuizDeadlineTimer({super.key, required this.endTime});

  @override
  State<QuizDeadlineTimer> createState() => _QuizDeadlineTimerState();
}

class _QuizDeadlineTimerState extends State<QuizDeadlineTimer> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.endTime.difference(now);

    setState(() {
      _timeLeft = difference.isNegative ? Duration.zero : difference;
    });

    if (_timeLeft == Duration.zero) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '00:00:00';

    final days = duration.inDays > 0 ? '${duration.inDays}d ' : '';
    final hours = (duration.inHours % 24).toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$days$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: StatusColors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StatusColors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timer_outlined,
            color: StatusColors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Closes in: ',
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: AppColors.secondary,
            ),
          ),
          Text(
            _formatDuration(_timeLeft),
            style: AppStyles.mobileBodySmallSb.copyWith(
              color: StatusColors.orange,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
