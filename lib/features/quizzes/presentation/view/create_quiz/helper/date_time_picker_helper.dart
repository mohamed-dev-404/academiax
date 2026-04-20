import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';

class DateTimePickerHelper {
  /// Orchestrates the selection of both Date and Time sequentially.
  /// This shared logic works for both Mobile and Web layouts.
  static Future<void> pickStartDateTime(BuildContext context) async {
    final cubit = context.read<CreateQuizCubit>();

    // 1. Trigger Date Picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restricts selection to future dates only
      lastDate: DateTime(2100),
      builder: (context, child) => _applyDatePickerTheme(context, child!),
    );

    // Stop execution if user cancels or if the widget is no longer in the tree
    if (pickedDate == null || !context.mounted) return;

    // Update the Date in the Cubit state
    cubit.updateDate(pickedDate);

    // 2. Trigger Time Picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => _applyTimePickerTheme(context, child!),
    );

    if (pickedTime == null || !context.mounted) return;

    // Update the Time in the Cubit state
    cubit.updateTime(pickedTime);
  }

  /// Applies uniform styling to the Date Picker dialog.
  static Widget _applyDatePickerTheme(BuildContext context, Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          onSurface: AppColors.primaryDark,
        ),
      ),
      child: child,
    );
  }

  /// Applies uniform styling to the Time Picker,
  /// including specific fixes for the AM/PM selector.
  static Widget _applyTimePickerTheme(BuildContext context, Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          onSurface: AppColors.primaryDark,
        ),
        timePickerTheme: TimePickerThemeData(
          // Customize the AM/PM toggle background
          dayPeriodColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppColors.primary
                : Colors.transparent;
          }),
          // Customize the AM/PM toggle text color
          dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? Colors.white
                : AppColors.primaryDark;
          }),
          // Add a border to the AM/PM selector for better definition
          dayPeriodBorderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.0,
          ),
        ),
      ),
      child: child,
    );
  }
}
