import 'package:flutter/material.dart';
import 'package:sams_app/features/home/data/models/course_model.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/course_title_row.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/instructor_row.dart';

//* Positioned overlay for the course card text data
class CourseCardContent extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final CourseModel course;
  final bool isMobile;

  const CourseCardContent({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.course,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      //? Dynamic padding to ensure text doesn't overlap background graphics
      left: cardWidth * 0.10,
      right: cardWidth * 0.05,
      top: isMobile ? cardHeight * 0.2 : cardHeight * 0.17,
      bottom: cardHeight * 0.08,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CourseTitleRow(
            course: course,
            isMobile: isMobile,
            w: cardWidth,
            h: cardHeight,
          ),
          InstructorRow(
            course: course,
            w: cardWidth,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}
