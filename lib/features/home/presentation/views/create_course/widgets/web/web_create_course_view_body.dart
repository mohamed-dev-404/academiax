import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_state.dart';
import 'package:sams_app/features/home/presentation/logic/mixin_create_course.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/basic_information_section.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/create_course_button.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/grade_breakdown_section.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_header.dart';

//* The core course creation form for instructors, utilizing a mixin for logic separation and a BlocConsumer for state-driven UI updates
class WebCreateCourseViewBody extends StatefulWidget {
  const WebCreateCourseViewBody({super.key});

  @override
  State<WebCreateCourseViewBody> createState() =>
      _WebCreateCourseViewBodyState();
}

class _WebCreateCourseViewBodyState extends State<WebCreateCourseViewBody>
    with CreateCourseLogic {
  @override
  void initState() {
    super.initState();
    initCourseLogic();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
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
        return Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: WebHomeHeader(), // Header
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)), // Spacing
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'Create Course',
                      style: AppStyles.webTitleMediumMd,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)), // Spacing
              // Forms Side by Side
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Basic Information Section
                      Expanded(
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
                        //  BasicInformationSection(
                        //   totalController: totalGradeController,
                        //   finalController: finalExamController,
                        //   courseNameController: courseNameController,
                        //   courseCodeController: courseCodeController,
                        // ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        //* Grade Breakdown Section
                        child: GradeBreakdownSection(
                          fields: classworkFields,
                          remaining: remainingPoints,
                          limit: totalClassworkLimit,
                          onAddField: addDynamicField,
                          onRemoveField: removeDynamicField,
                          status: gradeStatus,
                          totalInput:
                              double.tryParse(totalGradeController.text) ?? 0,
                          finalInput:
                              double.tryParse(finalExamController.text) ?? 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)), // Spacing
              SliverToBoxAdapter(
                // Create Course Button
                child: CreateCourseButton(
                  isLoading: state is CreateCourseLoading,
                  onPressed: () => submitCourse(context),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)), // Spacing
            ],
          ),
        );
      },
    );
  }
}
