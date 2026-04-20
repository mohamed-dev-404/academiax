import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/features/home/data/models/course_model.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/course_card_content.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/course_card_decoration.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/course_card_menu.dart';

//* Main entry point for the Course Card UI component
class CustomCourseCard extends StatelessWidget {
  final UserRole role;
  final CourseModel course;
  final bool isMobile;
  const CustomCourseCard({
    super.key,
    required this.course,
    required this.role,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    //? Aspect ratios defined to match design specs for different platforms
    final double aspectRatio = isMobile ? (343 / 135) : (301 / 240);
    final double borderRadius = isMobile ? 15 : 20;

    return InkWell(
      //! nav to course details
      onTap: () => context.push(
        RoutesName.courseDetails,
        extra: CourseHeaderCardModel(
          courseId: course.id.toString(),
          title: course.name,
          instructor: course.instructor,
        ),
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.primaryLightHover,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth;
              final cardHeight = constraints.maxHeight;

              return Stack(
                children: [
                  /// Layer 1: Background Decorations
                  CourseCardDecorations(
                    cardWidth: cardWidth,
                    h: cardHeight,
                    isMobile: isMobile,
                  ),

                  /// Layer 2: Management Menu (Share, Delete, etc.)
                  CourseCardMenu(
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    role: role,
                    isMobile: isMobile,
                    course: course,
                  ),

                  /// Layer 3: Course Text Content
                  CourseCardContent(
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    course: course,
                    isMobile: isMobile,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
