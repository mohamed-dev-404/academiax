import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/helper/date_time_picker_helper.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/duration_input_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/header_section.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/date_time_picker_field.dart';

/// A unified "Smart Form" screen for both creating and editing a quiz.
///
/// Behaviour is driven entirely by [CreateQuizFormArgs]:
/// - [CreateQuizFormArgs.isEditMode] == false → Create mode (blank form, "Create Quiz" title)
/// - [CreateQuizFormArgs.isEditMode] == true  → Edit mode (pre-filled form, "Edit Quiz" title,
///   classwork field hidden)
///
class CreateQuizMobileLayout extends StatelessWidget {
  const CreateQuizMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    return Scaffold(
      bottomNavigationBar: BlocBuilder<CreateQuizCubit, CreateQuizState>(
        builder: (context, state) =>
            _buildBottomButton(context, state is CreateQuizLoading),
      ),
      body: Form(
        key: cubit.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // * ──────────────────── Header Section ────────────────────
              HeaderSection(isEditMode: cubit.isEditMode),

              // * ──────────────────── Form Section ────────────────────
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
                        const TitledInputField(
                          label: 'Assigned Classwork',
                          child: ClassworkSelectorField(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ? ─── Title ───
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

                      // ? ─── Description ───
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

                      // ? ─── Start Time ───
                      BlocBuilder<CreateQuizCubit, CreateQuizState>(
                        buildWhen: (prev, curr) => curr is CreateQuizUIUpdated,
                        builder: (context, state) {
                          return TitledInputField(
                            label: 'Start Time',
                            child: DateTimePickerField(
                              controller: cubit.startTimeDisplayController,
                              onTap: () =>
                                  DateTimePickerHelper.pickStartDateTime(
                                    context,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // ? ─── Duration ───
                      TitledInputField(
                        label: 'Duration',
                        child: DurationInputField(
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

  // * ──────────────────── Bottom Button ────────────────────

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
                  child: AppAnimatedLoadingIndicator(),
                ),
              ],
            )
          : AppButton(
              model: AppButtonStyleModel(
                label: cubit.isEditMode ? 'Save Changes' : 'Create Quiz',
                onPressed: cubit.onSubmit,
              ),
            ),
    );
  }
}
