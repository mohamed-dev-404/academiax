import 'package:flutter/material.dart';
import 'package:sams_app/core/models/input_field_model.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/create_course_form_section.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/shared/input_field_title.dart';

// //* Form section specifically for gathering essential course details
// class BasicInformationSection extends StatelessWidget {
//   const BasicInformationSection({
//     super.key,
//     required this.totalController,
//     required this.finalController,
//     required this.courseNameController,
//     required this.courseCodeController,
//   });

//   //? Controllers to manage state and validation for course inputs
//   final TextEditingController totalController;
//   final TextEditingController finalController;
//   final TextEditingController courseNameController;
//   final TextEditingController courseCodeController;

//   @override
//   Widget build(BuildContext context) {
//     return CreatecourseFormSection(
//       title: 'Basic Information',
//       children: [
//         InputFieldTile(
//           label: 'Course Name',
//           hint: 'e.g. Web Development',
//           textFieldType: TextFieldType.normal,
//           controller: courseNameController,
//         ),
//         InputFieldTile(
//           label: 'Course Code',
//           hint: 'e.g. CS101',
//           textFieldType: TextFieldType.normal,
//           controller: courseCodeController,
//         ),
//         InputFieldTile(
//           label: 'Total Grade',
//           hint: 'e.g. 100',
//           textFieldType: TextFieldType.numerical,
//           controller: totalController,
//         ),

//         InputFieldTile(
//           label: 'Final Exam',
//           hint: 'e.g. 60',
//           textFieldType: TextFieldType.numerical,
//           controller: finalController,
//         ),
//       ],
//     );
//   }
// }

class CustomBasicInformationSection extends StatelessWidget {
  const CustomBasicInformationSection({
    super.key,
    required this.sectionTitle, 
    required this.fields,       
  });

  final String sectionTitle;
  final List<InputFieldData> fields;

  @override
  Widget build(BuildContext context) {
    return CreatecourseFormSection(
      title: sectionTitle,
      children: fields.map((field) => InputFieldTile(
        label: field.label,
        hint: field.hint,
        textFieldType: field.type,
        controller: field.controller,
      )).toList(),
    );
  }
}