import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/mobile/mobile_home_view.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_view.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_state.dart';

//* The main home screen for both instructors and students
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UpdateNameSuccess && CurrentRole.role == UserRole.instructor) {
          context.read<HomeCubit>().fetchMyCourses(role: CurrentRole.role);
        }
      },
      child: AdaptiveLayout(
        mobileLayout: (context) => const MobileHomeView(),
        webLayout: (context) => const WebHomeView(),
      ),
    );
  }
}
