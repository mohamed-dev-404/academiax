import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/grades/presentation/view/widget/mobile/grades_mobile_layout.dart';
import 'package:sams_app/features/grades/presentation/view/widget/web/grades_web_layout.dart';

class GradesTabView extends StatelessWidget {
  final String courseId;
  const GradesTabView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (BuildContext context) {
        return GradesMobileLayout(courseId: courseId);
      },
      webLayout: (BuildContext context) {
        return GradesWebLayout(courseId: courseId);
      },
    );
  }
}
