import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_state.dart';
import 'package:sams_app/features/home/presentation/logic/mixin_create_course.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/basic_information_section.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/create_course_button.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/grade_breakdown_section.dart';

//* The core course creation form for instructors, utilizing a mixin for logic separation and a BlocConsumer for state-driven UI updates.
class MobileCreateCourseViewBody extends StatefulWidget {
  const MobileCreateCourseViewBody({super.key});

  @override
  State<MobileCreateCourseViewBody> createState() =>
      _MobileCreateCourseViewBodyState();
}

//* State class for MobileCreateCourseViewBody with CreateCourseLogic mixin
class _MobileCreateCourseViewBodyState extends State<MobileCreateCourseViewBody>
    with CreateCourseLogic {
  //* Initialization of the controllers
  @override
  void initState() {
    super.initState();
    initCourseLogic();
  }

  //! Dispose the controllers
  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      //? Optimized to only trigger listeners on 'CourseActionState' to avoid unnecessary snackbar rebuilds or pops.
      listenWhen: (previous, current) => current is CourseActionState,
      listener: (context, state) {
        if (state is CreateCourseSuccess) {
          AppSnackBar.success(context, state.message);
          Navigator.pop(context);
        } else if (state is CreateCourseFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: CustomScrollView(
              //? CustomScrollView is used to ensure the form remains accessible even when the keyboard is visible or fields are dynamically added.
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  //? Displays the basic information section
                  child: CustomBasicInformationSection(
                    sectionTitle: 'Basic Information',
                    fields: [
                      InputFieldData(
                        label: 'Course Name',
                        hint: 'e.g. Web Development',
                        controller: courseNameController,
                      ),
                      InputFieldData(
                        label: 'Course Code',
                        hint: 'e.g. CS101',
                        controller: courseCodeController,
                      ),
                      InputFieldData(
                        label: 'Total Grade',
                        hint: 'e.g. 100',
                        controller: totalGradeController,
                        type: TextFieldType.numerical,
                      ),
                      InputFieldData(
                        label: 'Final Exam',
                        hint: 'e.g. 60',
                        controller: finalExamController,
                        type: TextFieldType.numerical,
                      ),
                    ],
                  ),
                  // BasicInformationSection(
                  //   totalController: totalGradeController,
                  //   finalController: finalExamController,
                  //   courseNameController: courseNameController,
                  //   courseCodeController: courseCodeController,
                  // ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: GradeBreakdownSection(
                    //? Manages dynamic fields for classwork; allowing instructors to customize grading criteria beyond the final exam.
                    fields: classworkFields,
                    remaining: remainingPoints,
                    limit: totalClassworkLimit,
                    onAddField: addDynamicField,
                    onRemoveField: removeDynamicField,
                    status: gradeStatus,
                    totalInput: double.tryParse(totalGradeController.text) ?? 0,
                    finalInput: double.tryParse(finalExamController.text) ?? 0,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
                SliverToBoxAdapter(
                  //? Displays the create course button
                  child: CreateCourseButton(
                    isLoading: state is CreateCourseLoading,
                    onPressed: () => submitCourse(context),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
        );
      },
    );
  }
}
