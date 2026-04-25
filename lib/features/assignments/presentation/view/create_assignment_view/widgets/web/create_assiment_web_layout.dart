import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/logic/date_time_picker_helper.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/course_assignment_section.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/date_time_picker_field.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/header_section.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/plagiarism_section.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/uploading_overlay.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_state.dart';

class CreateAssignmentWebLayout extends StatefulWidget {
  const CreateAssignmentWebLayout({super.key});

  @override
  State<CreateAssignmentWebLayout> createState() =>
      _CreateAssignmentWebLayoutState();
}

class _CreateAssignmentWebLayoutState extends State<CreateAssignmentWebLayout> {
  final GlobalKey<CourseAssignmentSectionState> filesKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth(context);
    final cubit = context.read<CreateAssignmentCubit>();
    const bool isEditMode = false;

    return BlocBuilder<CreateAssignmentCubit, CreateAssignmentState>(
      buildWhen: (_, curr) => curr is CreateAssignmentLoading,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: BlocListener<CreateAssignmentCubit, CreateAssignmentState>(
            listener: (context, state) {
              if (state is CreateAssignmentSuccess) {
                AppToast.success(context, state.message);
                context.pop(state.assignment);
              }
              if (state is CreateAssignmentFailure) {
                AppToast.error(context, state.errMessage);
              }
            },
            child: Stack(
              children: [
                Form(
                  key: cubit.formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: Column(
                        children: [
                          const HeaderSection(),
                          const SizedBox(height: 32),
                          width < 755
                              ? Column(
                                  children: [
                                    _buildDetailsCard(isEditMode, cubit),
                                    const SizedBox(height: 24),
                                    _buildSettingsCard(context, cubit),
                                    const SizedBox(height: 24),
                                    _buildSubmitButton(
                                      isEditMode,
                                      cubit,
                                      state,
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _buildDetailsCard(
                                        isEditMode,
                                        cubit,
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          _buildSettingsCard(context, cubit),
                                          const SizedBox(height: 24),
                                          _buildSubmitButton(
                                            isEditMode,
                                            cubit,
                                            state,
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
                if (state is CreateAssignmentLoading) const UploadingOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(
    bool isEditMode,
    CreateAssignmentCubit cubit,
    CreateAssignmentState state,
  ) {
    return SizedBox(
      width: 250,
      child: AppButton(
        model: AppButtonStyleModel(
          label: isEditMode ? 'Save Changes' : 'Create Assignment',
          onPressed: state is CreateAssignmentLoading
              ? null
              : () {
                  if (!cubit.formKey.currentState!.validate()) return;
                  final files = filesKey.currentState?.allPickedFiles ?? [];
                  cubit.onSubmit(selectedFiles: files);
                },
        ),
      ),
    );
  }

  Widget _buildDetailsCard(bool isEditMode, CreateAssignmentCubit cubit) {
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

          const PlagiarismSection(),

          const SizedBox(height: 24),

          if (!isEditMode) ...[
            const TitledInputField(
              label: 'Assigned Classwork',
              child: ClassworkSelectorField(),
            ),
            const SizedBox(height: 24),
          ],
          TitledInputField(
            label: 'Assignment Title',
            child: AppTextField(
              controller: cubit.titleController,
              hintText: 'Enter assignment title',
              textFieldType: TextFieldType.normal,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(height: 24),
          TitledInputField(
            label: 'Description',
            child: AppTextField(
              controller: cubit.descriptionController,
              hintText: 'Enter a brief description',
              textFieldType: TextFieldType.normal,
              minLines: 3,
              textInputAction: TextInputAction.newline,
            ),
          ),
          const SizedBox(height: 24),
          //  CourseAssignmentSection(key: filesKey, initialItems: const []),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, CreateAssignmentCubit cubit) {
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
            'Deadline & Access',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<CreateAssignmentCubit, CreateAssignmentState>(
            buildWhen: (prev, curr) => curr is CreateAssignmentUIUpdated,
            builder: (context, state) {
              return TitledInputField(
                label: 'Due Date & Time',
                child: DateTimePickerField(
                  controller: cubit.dueDateDisplayController,
                  onTap: () => DateTimePickerHelper.pickStartDateTime(context),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          CourseAssignmentSection(key: filesKey, initialItems: const []),
        ],
      ),
    );
  }
}
