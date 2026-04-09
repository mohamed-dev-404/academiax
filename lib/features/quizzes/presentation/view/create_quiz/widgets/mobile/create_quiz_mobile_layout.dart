import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/date_time_picker_field.dart';

/// A unified "Smart Form" screen for both creating and editing a quiz.
///
/// Behaviour is driven entirely by [CreateQuizFormArgs]:
/// - [CreateQuizFormArgs.isEditMode] == false → Create mode (blank form, "Create Quiz" title)
/// - [CreateQuizFormArgs.isEditMode] == true  → Edit mode (pre-filled form, "Edit Quiz" title,
///   classwork field locked)
///
/// Data flow is ready for Cubit integration — see the TODO comments at the
/// submit handler.
class CreateQuizMobileLayout extends StatelessWidget {
  const CreateQuizMobileLayout({super.key});

  // ──────────────────── Date & Time Picker ────────────────────
  Future<void> _pickStartDateTime(BuildContext context) async {
    final cubit = context.read<CreateQuizCubit>();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prohibits past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !context.mounted) return;
    cubit.updateDate(pickedDate);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null || !context.mounted) return;
    cubit.updateTime(pickedTime);
  }

  // ──────────────────── Build ────────────────────

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    return Scaffold(
      // appBar: MobileCustomAppBar(
      //   title: cubit.isEditMode ? 'Edit Quiz' : 'Create Quiz',
      // ),
      bottomNavigationBar: BlocBuilder<CreateQuizCubit, CreateQuizState>(
        builder: (context, state) =>
            _buildBottomButton(context, state is CreateQuizLoading),
      ),
      body: Form(
        key: cubit.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _SectionHeader(isEditMode: cubit.isEditMode),
              Transform.translate(
                offset: const Offset(0, -25),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (!cubit.isEditMode) ...[
                        // Wrap with BlocBuilder to fix the rebuild issue
                        BlocBuilder<CreateQuizCubit, CreateQuizState>(
                          buildWhen: (prev, curr) =>
                              curr is CreateQuizUIUpdated,
                          builder: (context, state) {
                            return TitledInputField(
                              label: 'Assigned Classwork',
                              child: ClassworkSelectorField(
                                selectedClasswork: cubit.selectedClasswork,
                                classworkItems: mockClassworkItems,
                                onSelected: cubit.onClassworkSelected,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ─── Title ───
                      TitledInputField(
                        label: 'Title',
                        child: AppTextField(
                          hintText: 'Enter quiz title',
                          controller: cubit.titleController,
                          textFieldType: TextFieldType.normal,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ─── Description ───
                      TitledInputField(
                        label: 'Description',
                        child: AppTextField(
                          hintText: 'Enter a brief description',
                          controller: cubit.descriptionController,
                          textFieldType: TextFieldType.normal,
                          minLines: 3,
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ─── Start Time ───
                      BlocBuilder<CreateQuizCubit, CreateQuizState>(
                        buildWhen: (prev, curr) => curr is CreateQuizUIUpdated,
                        builder: (context, state) {
                          return TitledInputField(
                            label: 'Start Time',
                            child: DateTimePickerField(
                              controller: cubit.startTimeDisplayController,
                              onTap: () => _pickStartDateTime(context),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // ─── Duration ───
                      TitledInputField(
                        label: 'Duration',
                        child: _DurationInputField(
                          controller: cubit.durationController,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────── Bottom Button ────────────────────

  Widget _buildBottomButton(BuildContext context, bool isLoading) {
    final cubit = context.read<CreateQuizCubit>();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isLoading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : AppButton(
              model: AppButtonStyleModel(
                label: cubit.isEditMode ? 'Save Changes' : 'Continue',
                onPressed: cubit.onSubmit,
              ),
            ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Private sub-widgets (scoped to this file — not reused elsewhere)
// ══════════════════════════════════════════════════════════════

/// Contextual header with title and subtitle that adapts to the form mode.
class _SectionHeader extends StatelessWidget {
  final bool isEditMode;
  const _SectionHeader({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 50),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEditMode ? 'MODIFICATION MODE' : 'NEW ASSIGNMENT',
              style: AppStyles.mobileBodyXsmallRg.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEditMode ? 'Edit Quiz Details' : 'Create New Quiz',
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            isEditMode
                ? 'Make sure to double-check the timing and classwork before saving.'
                : 'Fill in the details to set up a new assessment for your class.',
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: AppColors.whiteLight.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Digits-only field for quiz duration in minutes.
class _DurationInputField extends StatelessWidget {
  final TextEditingController controller;
  const _DurationInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: controller,
          hintText: 'e.g. 30',
          textFieldType: TextFieldType.numerical,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'mins',
                  style: AppStyles.mobileBodySmallMd.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Helper subtext
        Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Access deadline. Students can start until the last minute and finish their full attempt.',
                style: AppStyles.mobileBodyXsmallRg.copyWith(
                  color: AppColors.whiteDarkActive,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
