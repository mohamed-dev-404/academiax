import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/widgets/mobile/mobile_coures_header_card.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/mobile/mobile_tab_body_view.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/mobile/custom_mobile_tab_bar.dart';
import 'package:sams_app/features/course_details/presentation/view_models/course_navigation/course_navigation_cubit.dart';

/// Mobile course details shell.
///
/// Scroll behaviour:
///   • Header card scrolls away with content (not pinned).
///   • Tab bar sticks at the top once the header has scrolled out.
///   • Tab body fills the remaining space via Expanded + IndexedStack.
///
/// No GoRouter navigation on tab switch — everything is driven by
/// [CourseNavigationCubit.changeTab].
class TabBarMobileLayout extends StatelessWidget {
  const TabBarMobileLayout({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseNavigationCubit>();

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          // ! Header region — scrolls away as the user drags up.
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: MobileCoursesHeaderCard(
                  cardModel: cubit.courseModel,
                ),
              ),
            ),
          ],

          // ! Body region — tab bar always visible, content beneath it.
          body: BlocBuilder<CourseNavigationCubit, int>(
            builder: (context, currentIndex) {
              return Column(
                children: [
                  // * ── Sticky tab bar ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: CustomMobileTabBar(
                      tabs: cubit.visibleTabTitles,
                      currentIndex: currentIndex,
                      onTap: cubit.changeTab,
                    ),
                  ),

                  // * ── Tab content ────────────────────────────────────
                  Expanded(
                    child: MobileTabBodyView(
                      child: IndexedStack(
                        index: currentIndex,
                        children: tabs,
                      ),
                    ),
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
