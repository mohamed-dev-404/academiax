import 'package:flutter/widgets.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/web/web_course_header_card.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/courses_sliver_grid.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_header.dart';

class WebHomeViewBody extends StatelessWidget {
  const WebHomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Displays the header
        const SliverToBoxAdapter(child: WebHomeHeader()),
        // Displays the course header
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          sliver: SliverToBoxAdapter(
            child: WebCourseHeaderCard(
              cardModel: CourseHeaderCardModel(
                courseId: '',
                description:
                    'Stay informed about important campus news, academic updates, and events.',
                title: 'Courses',
              ),
            ),
          ),
        ),
        // Displays the 'My Courses' section
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          sliver: SliverToBoxAdapter(
            child: Text('My Courses', style: AppStyles.webTitleMediumSb),
          ),
        ),
        // Spacing
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // Displays the grid of courses
        const CoursesSliverGrid(),
        // spacing
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}
