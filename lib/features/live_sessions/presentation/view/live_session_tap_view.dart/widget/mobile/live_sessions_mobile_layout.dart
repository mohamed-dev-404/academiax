import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/logic/meeting_handler.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/create_session_dialog.dart';
import 'package:sams_app/features/live_sessions/presentation/view_model/cubit/meeting_cubit.dart';
import 'package:sams_app/features/live_sessions/presentation/view_model/cubit/meeting_state.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mobile_meeting_card.dart';

class LiveSessionsMobileLayout extends StatelessWidget {
  final String courseId;
  final bool isInstructor;
  final int instructorId;

  const LiveSessionsMobileLayout({
    super.key,
    required this.courseId,
    required this.isInstructor,
    this.instructorId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetingCubit, MeetingState>(
      listenWhen: (previous, current) =>
          current is JoinMeetingSuccess || current is JoinMeetingFailure,
      listener: (context, state) {
        if (state is JoinMeetingSuccess) {
          if (context.mounted) {
            MeetingHandler.launchExternalUrl(
              context,
              state.url,
              mode: LaunchMode.externalApplication,
            );
          }
        } else if (state is JoinMeetingFailure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        }
      },
      child: BlocBuilder<MeetingCubit, MeetingState>(
        buildWhen: (previous, current) =>
            current is FetchMeetingsLoading ||
            current is FetchMeetingsSuccess ||
            current is FetchMeetingsFailure,
        builder: (context, state) {
          if (state is FetchMeetingsLoading) {
            return const Center(child: AppAnimatedLoadingIndicator());
          } else if (state is FetchMeetingsSuccess) {
            final itemCount = isInstructor
                ? state.meetings.length + 1
                : state.meetings.length;

            if (itemCount == 0) {
              return const Center(child: Text('No Live Sessions found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (isInstructor && index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AddNewCard(
                      title: 'Schedule New Session',
                      isMobile: true,
                      onTap: () {
                        final meetingCubit = context.read<MeetingCubit>();
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider.value(
                            value: meetingCubit,
                            child: CreateSessionDialog(courseId: courseId),
                          ),
                        );
                      },
                    ),
                  );
                }

                final meetingIndex = isInstructor ? index - 1 : index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MobileMeetingCard(
                    meeting: state.meetings[meetingIndex],
                    isInstructor: isInstructor,
                    onJoin: () {
                      // Permission handling is done inside MeetingSessionCubit.
                      // We just trigger the API join here; navigation happens
                      // in the BlocListener above via JoinMeetingSuccess.
                      if (state.meetings[meetingIndex].isOngoing) {
                        context.read<MeetingCubit>().joinMeeting(
                          meetingId: state.meetings[meetingIndex].id,
                        );
                      }
                    },
                    onEnd: () => context.read<MeetingCubit>().endMeeting(
                      meetingId: state.meetings[meetingIndex].id,
                      courseId: courseId,
                    ),
                    onDelete: () => context.read<MeetingCubit>().deleteMeeting(
                      meetingId: state.meetings[meetingIndex].id,
                      courseId: courseId,
                    ),
                  ),
                );
              },
            );
          } else if (state is FetchMeetingsFailure) {
            return Center(child: Text(state.errMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
