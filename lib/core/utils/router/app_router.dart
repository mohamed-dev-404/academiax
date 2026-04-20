import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/router/build_route.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/general_error_page.dart';
import 'package:sams_app/features/Grades/presentation/view/grades_tab_view.dart';
import 'package:sams_app/features/announcements/presentation/view/announcements_tab_view.dart';
import 'package:sams_app/features/assignments/presentation/view/assiment_tap_view/assignments_tab_view.dart';
// Repos & Cubits
import 'package:sams_app/features/auth/data/repos/auth_repo.dart';
import 'package:sams_app/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:sams_app/features/auth/presentation/view_models/password_reset_cubit/password_reset_cubit.dart';
import 'package:sams_app/features/auth/presentation/view_models/sign_up_cubit/sign_up_cubit.dart';
import 'package:sams_app/features/auth/presentation/views/login/login_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/forgot_password_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/reset_password_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/verify_otp_view.dart';
// Views
import 'package:sams_app/features/auth/presentation/views/sign_up/activate_account_view.dart';
import 'package:sams_app/features/auth/presentation/views/sign_up/sign_up_view.dart';
import 'package:sams_app/features/course_code/presentation/view/course_code_tab_view.dart';
import 'package:sams_app/features/course_details/presentation/view/course_details_view.dart';
import 'package:sams_app/features/home/data/repos/home_repo.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/views/create_course/create_course_view.dart';
import 'package:sams_app/features/home/presentation/views/home/home_view.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_sessions_tab_view.dart';
import 'package:sams_app/features/materials/presentation/view/materials_tab_view.dart';
import 'package:sams_app/features/members_list/presentation/view/members_list_tab_view.dart';
import 'package:sams_app/features/profile/data/repos/profile_repo.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/views/profile/profile_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/quizzes_tab_view.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesName.login,
    errorBuilder: (context, state) => const GeneralErrorPage(),
    routes: [
      //! AUTH ROUTES

      //* 1. LOGIN ROUTE
      buildRoute(
        name: RoutesName.login,
        path: RoutesName.login,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(getIt<AuthRepo>()),
          child: const LoginView(),
        ),
      ),

      //* 2. SIGN UP FLOW SHELL
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => SignUpCubit(getIt<AuthRepo>()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            name: RoutesName.signUp,
            path: RoutesName.signUp,
            builder: (context, state) => const SignUpView(),
          ),
          GoRoute(
            name: RoutesName.activateAccount,
            path: RoutesName.activateAccount, // The OTP screen for Sign Up
            builder: (context, state) => const ActivateAccountView(),
          ),
        ],
      ),

      //* 3. PASSWORD RESET FLOW SHELL
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => PasswordResetCubit(getIt<AuthRepo>()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            name: RoutesName.forgotPassword,
            path: RoutesName.forgotPassword,
            builder: (context, state) => const ForgotPasswordView(),
          ),
          GoRoute(
            name: RoutesName.verifyOtp,
            path: RoutesName.verifyOtp, // The OTP screen for Password Reset
            builder: (context, state) => const VerifyOtpView(),
          ),
          GoRoute(
            name: RoutesName.resetPassword,
            path: RoutesName.resetPassword,
            builder: (context, state) => const ResetPasswordView(),
          ),
        ],
      ),

      //! HOME ROUTES

      // *  Home view
      buildRoute(
        name: RoutesName.courses,
        path: RoutesName.courses,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              HomeCubit(getIt.get<HomeRepo>(), role: CurrentRole.role)
                ..fetchMyCourses(role: CurrentRole.role),
          child: const HomeView(),
        ),
      ),
      //* Create course view
      buildRoute(
        name: RoutesName.createCourse,
        path: RoutesName.createCourse,
        builder: (context, state) {
          final homeCubit = state.extra as HomeCubit;

          return BlocProvider.value(
            value: homeCubit,
            child: const CreateCourseView(),
          );
        },
      ),

      //! PROFILE ROUTES

      //* Profile view
      buildRoute(
        name: RoutesName.profile,
        path: RoutesName.profile,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              ProfileCubit(getIt.get<ProfileRepo>())..getUserProfile(),
          child: const ProfileView(),
        ),
      ),

      //! COuRSE DETAILS ROUTES

      //* The main course details route with tabs as sub-routes
      // The ShellRoute wraps the layout around the changing tabs
      ShellRoute(
        builder: (context, state, child) {
          final courseId = state.pathParameters['courseId'] ?? '';

          // 1. Try to get from extra (Mobile navigation)
          final extraModel = state.extra as CourseHeaderCardModel?;

          // 2. Fallback to queryParams (Web refresh)
          final headerModel =
              extraModel ??
              CourseHeaderCardModel(
                title:
                    state.uri.queryParameters[ApiKeys.name] ?? 'Unknown Course',
                instructor:
                    state.uri.queryParameters[ApiKeys.instructor] ??
                    'Unknown Instructor',
              );

          return CourseDetailsView(
            courseId: courseId,
            headerModel: headerModel,
            child: child, // This is the tab content
          );
        },
        routes: [
          _buildTabRoute(
            RoutesName.materials,
            (id) => MaterialsTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.assignments,
            (id) => AssignmentsTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.announcements,
            (id) => AnnouncementsTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.grades,
            (id) => GradesTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.quizzes,
            (id) => QuizzesTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.liveSessions,
            (id) => LiveSessionsTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.courseCode,
            (id) => CourseCodeTabView(courseId: id),
          ),
          _buildTabRoute(
            RoutesName.membersList,
            (id) => MembersListTabView(courseId: id),
          ),
        ],
      ),
    ],
  );

  //? Helper method to build tab routes under course details
  static GoRoute _buildTabRoute(
    String path,
    Widget Function(String courseId) viewBuilder,
  ) {
    return GoRoute(
      path: '${RoutesName.courses}/:courseId/$path',
      builder: (context, state) =>
          viewBuilder(state.pathParameters['courseId'] ?? ''),
    );
  }
}
