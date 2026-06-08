import 'package:flutter/material.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/features/home/presentation/views/create_course/widgets/mobile/mobile_create_course_view_body.dart';

//* The mobile layout for the course creation form.
class MobileCreateCourseView extends StatelessWidget {
  const MobileCreateCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MobileCustomAppBar(
        title: 'Create Course',
      ),
      body: MobileCreateCourseViewBody(),
    );
  }
}
