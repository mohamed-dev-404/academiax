import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_state.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/custom_course_card.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/new_course_card.dart';

//* Grid layout optimized for Web/Tablet home screens
class CoursesSliverGrid extends StatefulWidget {
  const CoursesSliverGrid({super.key});

  @override
  State<CoursesSliverGrid> createState() => _CoursesSliverGridState();
}

class _CoursesSliverGridState extends State<CoursesSliverGrid> {
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _messageSubscription = context.read<HomeCubit>().messageStream.listen((
      msg,
    ) {
      if (mounted) {
        AppSnackBar.warning(context, msg);
      }
    });

    final role = context.read<HomeCubit>().role;
    context.read<HomeCubit>().fetchMyCourses(role: role);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeSuccess ||
          current is HomeFailure ||
          current is HomeLoading,
      builder: (context, state) {
        if (state is HomeSuccess) {
          //* Displays courses
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  //? The last item in the grid is always the "Create New Course" button
                  if (index == state.courses.length) {
                    return NewCourseCard(role: CurrentRole.role);
                  }
                  return CustomCourseCard(
                    course: state.courses[index],
                    role: CurrentRole.role,
                    isMobile: false,
                  );
                },
                childCount: state.courses.length + 1,
              ),
              //? dynamic Grid layout optimized for Web/Tablet
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 200,
              ),
            ),
          );
        } else if (state is HomeFailure) {
          //! Fallback UI if data fetching fails
          return SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUJoseKWLdz4o3GA4o_7P-b0cVClLE5o1RM0skmuTHYQ&s',
                ),
                const SizedBox(height: 10),
                Text(state.errMessage),
              ],
            ),
          );
        } else {
          //? Loading states
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: AppAnimatedLoadingIndicator()),
            ),
          );
        }
      },
    );
  }
}
