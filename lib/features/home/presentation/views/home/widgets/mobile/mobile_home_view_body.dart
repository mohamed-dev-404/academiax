import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/widgets/mobile/mobile_coures_header_card.dart';
import 'package:sams_app/core/widgets/shared/section_title.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/mobile/course_sliver_list.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/new_course_card.dart';

//* The main layout for the mobile home screen, organizing course summaries and the role-based 'NewCourseCard' in a scrollable view.
class MobileHomeViewBody extends StatelessWidget {
  const MobileHomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Displays the role-based 'NewCourseCard'
          const SliverPadding(padding: EdgeInsets.only(top: 20)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: MobileCoursesHeaderCard(
                cardModel: CourseHeaderCardModel(
                  courseId: '',
                  description: 'Explore Your Courses',
                  title: 'Courses',
                ),
              ),
            ),
          ),
          // Displays the 'My Courses' section
          const SliverToBoxAdapter(
            child: SectionTitle(
              title: 'My Courses',
            ),
          ),
          // Displays the role-based 'NewCourseCard'
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: NewCourseCard(
                role: CurrentRole.role,
                isMobile: true,
              ),
            ),
          ),
          // Displays the list of courses
          const CourseSliverList(),
        ],
      ),
    );
  }
}
