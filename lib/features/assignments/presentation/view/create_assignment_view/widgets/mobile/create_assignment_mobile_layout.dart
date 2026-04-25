import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/logic/date_time_picker_helper.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/course_assignment_section.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/date_time_picker_field.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/header_section.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/plagiarism_section.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_state.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/uploading_overlay.dart';

class CreateAssignmentMobileLayout extends StatefulWidget {
  const CreateAssignmentMobileLayout({super.key});

  @override
  State<CreateAssignmentMobileLayout> createState() =>
      _CreateAssignmentMobileLayoutState();
}

class _CreateAssignmentMobileLayoutState
    extends State<CreateAssignmentMobileLayout> {
  final GlobalKey<CourseAssignmentSectionState> filesKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateAssignmentCubit>();

    return BlocBuilder<CreateAssignmentCubit, CreateAssignmentState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          bottomNavigationBar: (cubit.state is! CreateAssignmentLoading)
              ? _buildBottomButton(cubit)
              : null,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // * ──────────────────── Header Section ────────────────────
                        const HeaderSection(),

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
                            child: Form(
                              key: cubit.formKey,
                              child: Column(
                                children: [
                                  const PlagiarismSection(),
                                  const SizedBox(height: 20),

                                  const TitledInputField(
                                    label: 'Assigned Classwork',
                                    child: ClassworkSelectorField(),
                                  ),
                                  const SizedBox(height: 20),

                                  // ? ─── Title ───
                                  TitledInputField(
                                    label: 'Title',
                                    child: AppTextField(
                                      controller: cubit.titleController,
                                      hintText: 'Enter Assignment title',
                                      textFieldType: TextFieldType.normal,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // ? ─── Description ───
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
                                  const SizedBox(height: 20),

                                  // ? ─── Due Time ───
                                  BlocBuilder<
                                    CreateAssignmentCubit,
                                    CreateAssignmentState
                                  >(
                                    buildWhen: (prev, curr) =>
                                        curr is CreateAssignmentUIUpdated,
                                    builder: (context, state) {
                                      return TitledInputField(
                                        label: 'Due Time',
                                        child: DateTimePickerField(
                                          controller:
                                              cubit.dueDateDisplayController,
                                          onTap: () =>
                                              DateTimePickerHelper.pickStartDateTime(
                                                context,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  //? --- Files ---
                                  CourseAssignmentSection(
                                    key: filesKey,
                                    initialItems: const [],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (cubit.state is CreateAssignmentLoading)
                  const UploadingOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  // * ──────────────────── Bottom Button ────────────────────
  Widget _buildBottomButton(CreateAssignmentCubit cubit) {
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
      child: AppButton(
        model: AppButtonStyleModel(
          label: 'Create Assignment',
          onPressed: () {
            if (!cubit.formKey.currentState!.validate()) return;
            final files = filesKey.currentState?.allPickedFiles ?? [];
            cubit.onSubmit(selectedFiles: files);
          },
        ),
      ),
    );
  }
}
