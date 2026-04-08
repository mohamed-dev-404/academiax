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
import 'package:sams_app/features/assignments/presentation/view/assignments_tab_view.dart';
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

// Quiz Views & Cubits
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/create_quiz_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/grade_submission_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/manage_questions_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/quiz_details_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/quizzes_tab_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/submissions_list_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/take_quiz_view.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/get_all_quizes_cubit/get_all_quizes_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/test_grading_cubit/test_grading_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/quiz_details_cubit/quiz_details_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/submissions_cubit/submissions_cubit.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesName.login,
    errorBuilder: (context, state) => const GeneralErrorPage(),
    routes: [
      // ! --- AUTH ROUTES ---

      // * --- LOGIN ROUTES ---
      buildRoute(
        name: RoutesName.login,
        path: RoutesName.login,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(getIt<AuthRepo>()),
          child: const LoginView(),
        ),
      ),
      // * --- SIGNUP ROUTES ---
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (context) => SignUpCubit(getIt<AuthRepo>()),
          child: child,
        ),
        routes: [
          GoRoute(
            name: RoutesName.signUp,
            path: RoutesName.signUp,
            builder: (context, state) => const SignUpView(),
          ),
          GoRoute(
            name: RoutesName.activateAccount,
            path: RoutesName.activateAccount,
            builder: (context, state) => const ActivateAccountView(),
          ),
        ],
      ),
      // * --- PASSWORD RESET ROUTES ---
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (context) => PasswordResetCubit(getIt<AuthRepo>()),
          child: child,
        ),
        routes: [
          GoRoute(
            name: RoutesName.forgotPassword,
            path: RoutesName.forgotPassword,
            builder: (context, state) => const ForgotPasswordView(),
          ),
          GoRoute(
            name: RoutesName.verifyOtp,
            path: RoutesName.verifyOtp,
            builder: (context, state) => const VerifyOtpView(),
          ),
          GoRoute(
            name: RoutesName.resetPassword,
            path: RoutesName.resetPassword,
            builder: (context, state) => const ResetPasswordView(),
          ),
        ],
      ),

      // ! --- HOME & PROFILE ---

      // * --- COURSES ROUTES ---
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
      // * --- CREATE COURSE ROUTES ---
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
      // * --- PROFILE ROUTES ---
      buildRoute(
        name: RoutesName.profile,
        path: RoutesName.profile,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              ProfileCubit(getIt.get<ProfileRepo>())..getUserProfile(),
          child: const ProfileView(),
        ),
      ),

      // ! --- COURSE DETAILS (THE TABS) ---
      ShellRoute(
        builder: (context, state, child) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final extraModel = state.extra as CourseHeaderCardModel?;
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
            child: child,
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

          // * --- QUIZZES TAB & FULL-SCREEN SUB-ROUTES
          _buildTabRoute(
            RoutesName.quizzes,
            (id) => BlocProvider(
              create: (context) =>
                  GetAllQuizesCubit(getIt<QuizRepository>())
                    ..getCourseQuizzes(courseId: id),
              child: QuizzesTabView(courseId: id),
            ),
            subRoutes: [
              // ? --- Quiz Details (Breaks out to Full Screen)
              GoRoute(
                name: RoutesName.quizDetails,
                path: '${RoutesName.quizDetails}/:quizId',
                parentNavigatorKey: navigatorKey,
                builder: (context, state) {
                  final quizId = state.pathParameters['quizId']!;
                  return BlocProvider(
                    create: (context) =>
                        QuizDetailsCubit(getIt<QuizRepository>()),
                    child: QuizDetailsView(quizId: quizId),
                  );
                },
                routes: [
                  GoRoute(
                    name: RoutesName.manageQuestions,
                    path: RoutesName.manageQuestions,
                    builder: (context, state) => BlocProvider(
                      create: (context) =>
                          ManageQuizCubit(getIt<QuizRepository>()),
                      child: const ManageQuestionsView(),
                    ),
                  ),
                  GoRoute(
                    name: RoutesName.submissionsList,
                    path: RoutesName.submissionsList,
                    parentNavigatorKey: navigatorKey, // FULL SCREEN
                    builder: (context, state) {
                      final quizId = state.pathParameters['quizId']!;
                      return BlocProvider(
                        create: (context) =>
                            SubmissionsCubit(getIt<QuizRepository>())
                              ..fetchAllSubmissions(quizId: quizId),
                        child: const SubmissionsListView(),
                      );
                    },
                    routes: [
                      GoRoute(
                        name: RoutesName.gradeSubmission,
                        path: '${RoutesName.gradeSubmission}/:submissionId',
                        builder: (context, state) => BlocProvider(
                          create: (context) =>
                              TestGradingCubit(getIt<QuizRepository>()),
                          child: const GradeSubmissionView(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    name: RoutesName.takeQuiz,
                    path: RoutesName.takeQuiz,
                    parentNavigatorKey: navigatorKey, // FULL SCREEN

                    builder: (context, state) {
                      final quizId = state.pathParameters['quizId']!;

                      final quizTitle = state.extra as String? ?? 'Quiz';

                      return BlocProvider(
                        create: (context) => TakeQuizCubit(
                          getIt<QuizRepository>(),
                        )..fetchQuestionsAndStart(quizId),
                        child: TakeQuizView(
                          quizTitle: quizTitle,
                        ),
                      );
                    },
                  ),
                ],
              ),
              // ? --- CREATE QUIZ (Breaks out to Full Screen)
              GoRoute(
                name: RoutesName.createQuiz,
                path: RoutesName.createQuiz,
                parentNavigatorKey: navigatorKey, // FULL SCREEN
                builder: (context, state) => BlocProvider(
                  create: (context) => ManageQuizCubit(getIt<QuizRepository>()),
                  child: const CreateQuizView(),
                ),
              ),
            ],
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

  // ! Helper method to build tab routes under course details
  static GoRoute _buildTabRoute(
    String path,
    Widget Function(String courseId) viewBuilder, {
    List<RouteBase> subRoutes = const [],
  }) {
    return GoRoute(
      name: path, // Ensuring the tab itself has a name
      path: '${RoutesName.courses}/:courseId/$path',
      builder: (context, state) =>
          viewBuilder(state.pathParameters['courseId'] ?? ''),
      routes: subRoutes,
    );
  }
}
