import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/helper/date_time_picker_helper.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/date_time_picker_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/duration_input_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/header_section.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';

class CreateQuizWebLayout extends StatelessWidget {
  const CreateQuizWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    final width = SizeConfig.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),

              child: Column(
                children: [
                  HeaderSection(isEditMode: cubit.isEditMode),
                  const SizedBox(height: 32),
                  width < 755
                      ? Column(
                          children: [
                            _buildSettingsCard(context, cubit),
                            const SizedBox(height: 24),
                            _buildSettingsCard(context, cubit),
                            const SizedBox(height: 24),

                            BlocBuilder<CreateQuizCubit, CreateQuizState>(
                              builder: (context, state) {
                                final isLoading = state is CreateQuizLoading;
                                return isLoading
                                    ? const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: AppAnimatedLoadingIndicator(),
                                      )
                                    : SizedBox(
                                        width: 250,
                                        child: AppButton(
                                          model: AppButtonStyleModel(
                                            label: cubit.isEditMode
                                                ? 'Save Changes'
                                                : 'Create Quiz',
                                            onPressed: cubit.onSubmit,
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column (Details)
                            Expanded(
                              flex: 3,
                              child: _buildDetailsCard(cubit),
                            ),
                            const SizedBox(width: 32),
                            // Right Column (Settings)
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildSettingsCard(context, cubit),
                                  const SizedBox(height: 24),

                                  BlocBuilder<CreateQuizCubit, CreateQuizState>(
                                    builder: (context, state) {
                                      final isLoading =
                                          state is CreateQuizLoading;
                                      return isLoading
                                          ? const SizedBox(
                                              width: 32,
                                              height: 32,
                                              child:
                                                  AppAnimatedLoadingIndicator(),
                                            )
                                          : SizedBox(
                                              width: 250,
                                              child: AppButton(
                                                model: AppButtonStyleModel(
                                                  label: cubit.isEditMode
                                                      ? 'Save Changes'
                                                      : 'Create Quiz',
                                                  onPressed: cubit.onSubmit,
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(CreateQuizCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteHover, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Information',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
          const SizedBox(height: 24),

          if (!cubit.isEditMode) ...[
            BlocBuilder<CreateQuizCubit, CreateQuizState>(
              buildWhen: (prev, curr) => curr is CreateQuizUIUpdated,
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
            const SizedBox(height: 24),
          ],

          TitledInputField(
            label: 'Quiz Title',
            child: AppTextField(
              hintText: 'Enter quiz title',
              controller: cubit.titleController,
              textFieldType: TextFieldType.normal,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(height: 24),

          TitledInputField(
            label: 'Description',
            child: AppTextField(
              hintText: 'Enter a brief description for the students',
              controller: cubit.descriptionController,
              textFieldType: TextFieldType.normal,
              minLines: 4,
              textInputAction: TextInputAction.newline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, CreateQuizCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.whiteHover, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timing & Access',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
          const SizedBox(height: 24),

          BlocBuilder<CreateQuizCubit, CreateQuizState>(
            buildWhen: (prev, curr) => curr is CreateQuizUIUpdated,
            builder: (context, state) {
              return TitledInputField(
                label: 'Start Date & Time',
                child: DateTimePickerField(
                  controller: cubit.startTimeDisplayController,
                  onTap: () => DateTimePickerHelper.pickStartDateTime(context),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          TitledInputField(
            label: 'Duration',
            child: DurationInputField(
              controller: cubit.durationController,
            ),
          ),
        ],
      ),
    );
  }
}
