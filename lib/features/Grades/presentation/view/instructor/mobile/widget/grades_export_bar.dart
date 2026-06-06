import 'package:flutter/material.dart';
import 'package:sams_app/features/Grades/presentation/view/instructor/shared/export_excel_button.dart';

class GradesExportBar extends StatelessWidget {
  const GradesExportBar({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ExportExcelButton(courseId: courseId)),
      ],
    );
  }
}
