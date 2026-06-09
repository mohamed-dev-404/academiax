import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ستحتاج لإضافة intl في الـ pubspec.yaml لتنسيق الوقت
import 'package:sams_app/core/functions/hide_keyboard.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_session_tap_view.dart/widget/shared/date_time_picker_field.dart';
import 'package:sams_app/features/live_sessions/presentation/view_model/cubit/meeting_cubit.dart';
import 'package:sams_app/features/live_sessions/presentation/view_model/cubit/meeting_state.dart';

class CreateSessionDialog extends StatefulWidget {
  final String courseId; // نحتاج الـ courseId لإنشاء الجلسة

  const CreateSessionDialog({super.key, required this.courseId});

  @override
  State<CreateSessionDialog> createState() => _CreateSessionDialogState();
}

class _CreateSessionDialogState extends State<CreateSessionDialog> {
  final TextEditingController _dateTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);
    final double screenWidth = SizeConfig.screenWidth(context);

    return AlertDialog(
      scrollable: true,
      backgroundColor: AppColors.whiteLight,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : screenWidth * 0.2,
        vertical: 20,
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      actionsPadding: const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Center(child: Text('Schedule New Session')),
      titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
        color: AppColors.primaryDarkHover,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // استخدام الـ Picker اللي بعته يا محمد
            DateTimePickerField(
              controller: _dateTimeController,
              onTap: () => _pickDateTime(context),
            ),
            const SizedBox(height: 16),
            Text(
              '• Select the start time for your live session.\n• Students will be able to join at this specific time.',
              style: AppStyles.mobileBodyMediumRg.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: BlocConsumer<MeetingCubit, MeetingState>(
            listener: _handleCreateStates,
            builder: (context, state) {
              if (state is CreateMeetingLoading) {
                return const CircularProgressIndicator(
                  color: AppColors.primaryDarkHover,
                );
              }
              return ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 230),
                child: CustomAppButton(
                  textColor: AppColors.whiteLight,
                  label: 'Create Session',
                  onPressed: () => _onCreatePressed(context),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // منطق اختيار التاريخ والوقت
  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!context.mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    _selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // تنسيق العرض في الـ TextField
    _dateTimeController.text = DateFormat('yyyy-MM-dd  hh:mm a').format(_selectedDateTime!);
  }

  void _onCreatePressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDateTime != null) {
      context.read<MeetingCubit>().createMeeting(
            courseId: widget.courseId,
            startTime: _selectedDateTime!,
          );
    }
  }

  void _handleCreateStates(BuildContext context, MeetingState state) {
    if (state is CreateMeetingSuccess) {
      if (context.mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        hideKeyboard(context);
        AppToast.success(context, state.message);
      }
    } else if (state is CreateMeetingFailure) {
      if (context.mounted) {
        AppToast.error(context, state.errMessage);
      }
    }
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    super.dispose();
  }
}