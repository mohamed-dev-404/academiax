import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/widgets/web/web_course_header_card.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/web/app_logo.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/web/custom_web_tab_bar.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/web/web_tab_body_view.dart';
import 'package:sams_app/features/course_details/presentation/view_models/course_navigation/course_navigation_cubit.dart';

/// Web course details shell.
///
/// Scroll behaviour mirrors the mobile layout:
///   • Tab bar stays in the AppBar — always visible.
///   • Header card is the first sliver in NestedScrollView — scrolls away.
///   • Tab body fills everything below via IndexedStack.
///
/// No GoRouter navigation on tab switch — driven by [CourseNavigationCubit].
class TabBarWebLayout extends StatelessWidget {
  const TabBarWebLayout({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseNavigationCubit>();

    return BlocBuilder<CourseNavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          // ! ── Sticky tab bar in AppBar ──────────────────────────────
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: AppLogo(),
                      ),
                      const SizedBox(width: 16),
                      CustomWebTabBar(
                        tabs: cubit.visibleTabTitles,
                        currentIndex: currentIndex,
                        onTap: cubit.changeTab,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ! ── Scrollable body ───────────────────────────────────────
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            // * Header region — course header card scrolls away.
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                  child: WebCourseHeaderCard(cardModel: cubit.courseModel),
                ),
              ),
            ],

            // * Body region — tab content.
            body: WebTabBodyView(
              child: IndexedStack(
                index: currentIndex,
                children: tabs,
              ),
            ),
          ),
        );
      },
    );
  }
}
