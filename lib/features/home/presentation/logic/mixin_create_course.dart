import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/features/home/data/models/classwork_model.dart';
import 'package:sams_app/features/home/data/models/create_course_model.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';

//* Mixin for handling course creation logic
mixin CreateCourseLogic<T extends StatefulWidget> on State<T> {
  // ! Controllers - Main form controllers
  final TextEditingController totalGradeController = TextEditingController();
  final TextEditingController finalExamController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ! Dynamic Fields - Holds nameController + gradeController
  final List<Map<String, dynamic>> classworkFields = [];

  double remainingPoints = 0;
  double totalClassworkLimit = 0;

  // ! Init - Attach listeners + add default fields
  void initCourseLogic() {
    totalGradeController.addListener(_recalculateGrades);
    finalExamController.addListener(_recalculateGrades);

    _addDefaultFields();
  }

  // ! Grade Calculation - Recalculate remaining points dynamically
  void _recalculateGrades() {
    final double total = double.tryParse(totalGradeController.text) ?? 0;
    final double finalExam = double.tryParse(finalExamController.text) ?? 0;

    totalClassworkLimit = total - finalExam;

    double currentSum = 0;
    for (var field in classworkFields) {
      currentSum += double.tryParse(field['gradeController'].text) ?? 0;
    }

    setState(() {
      remainingPoints = totalClassworkLimit - currentSum;
    });
  }

  // ! Add Field - Adds new classwork item
  void addDynamicField({String label = ''}) {
    final nameController = TextEditingController(text: label);
    final gradeController = TextEditingController()
      ..addListener(_recalculateGrades);

    setState(() {
      classworkFields.add({
        'nameController': nameController,
        'gradeController': gradeController,
      });
    });
  }

  // ! Remove Field - Dispose controllers before removing
  void removeDynamicField(int index) {
    final field = classworkFields[index];

    field['nameController'].dispose();
    field['gradeController'].dispose();

    setState(() {
      classworkFields.removeAt(index);
    });

    _recalculateGrades();
  }

  // ! Build Classwork List - Convert controllers to model list
  List<ClassworkModel> _buildClassworkList() {
    return classworkFields.map((field) {
      return ClassworkModel(
        name: field['nameController'].text.trim(),
        points: double.tryParse(field['gradeController'].text) ?? 0.0,
      );
    }).toList();
  }

  // ! Validation - Ensure grade distribution equals 100%
  bool _isGradeDistributionValid() {
    return remainingPoints.abs() <= 0.001;
  }

  // ! Submit Course - Validate → Build → Send to Cubit
  void submitCourse(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    if (!_isGradeDistributionValid()) {
      _showDistributionError(context);
      return;
    }

    final courseData = CreateCourseModel(
      name: courseNameController.text.trim(),
      academicCode: courseCodeController.text.trim(),
      totalGrades: double.parse(totalGradeController.text),
      finalExam: double.parse(finalExamController.text),
      classwork: _buildClassworkList(),
    );

    context.read<HomeCubit>().createCourse(course: courseData);
  }

  // ! Error Snackbar - Shows grade distribution error
  void _showDistributionError(BuildContext context) {
    AppSnackBar.error(
      context,
      (remainingPoints > 0)
          ? 'Still have ${remainingPoints.toStringAsFixed(0)} points left!'
          : 'Exceeded by ${remainingPoints.abs().toStringAsFixed(0)} points!',
    );
  }

  // ! Dispose - Prevent memory leaks
  void disposeControllers() {
    totalGradeController.dispose();
    finalExamController.dispose();
    courseNameController.dispose();
    courseCodeController.dispose();

    for (var field in classworkFields) {
      field['nameController'].dispose();
      field['gradeController'].dispose();
    }
  }

  // ! Default Fields - Initial predefined classwork items
  void _addDefaultFields() {
    addDynamicField(label: 'Midterm');
    addDynamicField(label: 'Assignment 1');
    addDynamicField(label: 'Quiz 1');
  }

  //! Grade Status - Determines the current state of grade distribution for UI feedback
  GradeStatus get gradeStatus {
    final double total = double.tryParse(totalGradeController.text) ?? 0;
    final double finalExam = double.tryParse(finalExamController.text) ?? 0;

    // 1. Initial State: Missing core grade information
    if (total <= 0 || finalExam <= 0) return GradeStatus.remaining;

    // 2. Edge Case: Final exam equals total grade and no classwork points assigned yet
    if (total == finalExam &&
        classworkFields.every(
          (f) => (double.tryParse(f['gradeController'].text) ?? 0) == 0,
        )) {
      return GradeStatus.remaining;
    }

    // 3. Normal Distribution States
    if (remainingPoints > 0) {
      return GradeStatus.remaining; // Still points left to assign
    }
    if (remainingPoints.abs() <= 0.001) {
      return GradeStatus.done; // Perfectly balanced
    }

    // 4. Error State: Points exceeded total limit
    return GradeStatus.exceeded;
  }
}

//* Grade Status Enum - Represents the state of grade distribution for UI feedback
enum GradeStatus { remaining, done, exceeded }
