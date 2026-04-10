import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/router/router_payload_cache.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/general_error_page.dart';

// Auth
import 'package:sams_app/features/auth/data/repos/auth_repo.dart';
import 'package:sams_app/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:sams_app/features/auth/presentation/view_models/password_reset_cubit/password_reset_cubit.dart';
import 'package:sams_app/features/auth/presentation/view_models/sign_up_cubit/sign_up_cubit.dart';
import 'package:sams_app/features/auth/presentation/views/login/login_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/forgot_password_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/reset_password_view.dart';
import 'package:sams_app/features/auth/presentation/views/password_reset/verify_otp_view.dart';
import 'package:sams_app/features/auth/presentation/views/sign_up/activate_account_view.dart';
import 'package:sams_app/features/auth/presentation/views/sign_up/sign_up_view.dart';

// Home & Profile
import 'package:sams_app/features/course_details/presentation/view/course_details_view.dart';
import 'package:sams_app/features/home/data/repos/home_repo.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/views/create_course/create_course_view.dart';
import 'package:sams_app/features/home/presentation/views/home/home_view.dart';
import 'package:sams_app/features/profile/data/repos/profile_repo.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/views/profile/profile_view.dart';

// Quiz
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/create_quiz_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/model/create_quiz_form_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/grade_submission_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/manage_questions_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_details/quiz_details_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/submissions_list/submissions_list_view.dart';
import 'package:sams_app/features/quizzes/presentation/view/take_quiz/take_quiz_view.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/grading_cubit/grading_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/manage_quiz_cubit/manage_quiz_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/quiz_details_cubit/quiz_details_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/submissions_cubit/submissions_cubit.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/take_quiz_cubit/take_quiz_cubit.dart';

/// A robust cache system for GoRouter `extra` payloads.
///
/// WHY THIS IS NEEDED: GoRouter is fundamentally designed for Web URLs. When
/// navigating "Back" (or rebuilding the stack), GoRouter recreates previous
/// or web back-button presses. This cache acts as our own bulletproof preserver.

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Returns user to HomeView actively bypassing null paths. Required for F5
  /// browser hard refreshes where state memory context.extra drops.
  static Widget _fallbackHome() {
    return BlocProvider(
      create: (_) =>
          HomeCubit(getIt<HomeRepo>(), role: CurrentRole.role)
            ..fetchMyCourses(role: CurrentRole.role),
      child: const HomeView(),
    );
  }

  static final appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesName.login,
    errorBuilder: (context, state) => const GeneralErrorPage(),
    routes: [
      // ─────────────────────────────────────────────────────────────────────
      // AUTHENTICATION
      // ─────────────────────────────────────────────────────────────────────
      GoRoute(
        name: RoutesName.login,
        path: RoutesName.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(getIt<AuthRepo>()),
          child: const LoginView(),
        ),
      ),

      // Sign-up flow: shared cubit
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) => SignUpCubit(getIt<AuthRepo>()),
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

      // Password reset flow: shared cubit
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) => PasswordResetCubit(getIt<AuthRepo>()),
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

      // ─────────────────────────────────────────────────────────────────────
      // HOME & PROFILE
      // ─────────────────────────────────────────────────────────────────────
      GoRoute(
        name: RoutesName.courses,
        path: RoutesName.courses,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              HomeCubit(getIt<HomeRepo>(), role: CurrentRole.role)
                ..fetchMyCourses(role: CurrentRole.role),
          child: const HomeView(),
        ),
      ),

      GoRoute(
        name: RoutesName.createCourse,
        path: RoutesName.createCourse,
        builder: (context, state) {
          final homeCubit = RouterPayloadCache.get<HomeCubit>(
            RoutesName.createCourse,
            state.extra,
          );
          if (homeCubit == null) return _fallbackHome();
          return BlocProvider.value(
            value: homeCubit,
            child: const CreateCourseView(),
          );
        },
      ),

      GoRoute(
        name: RoutesName.profile,
        path: RoutesName.profile,
        builder: (context, state) => BlocProvider(
          create: (_) => ProfileCubit(getIt<ProfileRepo>())..getUserProfile(),
          child: const ProfileView(),
        ),
      ),

      // ─────────────────────────────────────────────────────────────────────
      // COURSE DETAILS
      // ─────────────────────────────────────────────────────────────────────
      GoRoute(
        name: RoutesName.courseDetails,
        path: RoutesName.courseDetails,
        builder: (context, state) {
          final model = RouterPayloadCache.get<CourseHeaderCardModel>(
            RoutesName.courseDetails,
            state.extra,
          );
          if (model == null) return _fallbackHome();
          return CourseDetailsView(courseModel: model);
        },
      ),

      // ─────────────────────────────────────────────────────────────────────
      // QUIZ STANDALONE ROUTES
      // ─────────────────────────────────────────────────────────────────────
      GoRoute(
        name: RoutesName.quizDetails,
        path: RoutesName.quizDetails,
        builder: (context, state) {
          final extra = RouterPayloadCache.get<Map<String, dynamic>>(
            RoutesName.quizDetails,
            state.extra,
          );
          if (extra == null) return _fallbackHome();
          final quizId = extra['quizId'] as String? ?? '';

          return BlocProvider(
            create: (_) => QuizDetailsCubit(getIt<QuizRepository>()),
            child: QuizDetailsView(quizId: quizId),
          );
        },
      ),

      GoRoute(
        name: RoutesName.createQuiz,
        path: RoutesName.createQuiz,
        builder: (context, state) {
          final extra =
              RouterPayloadCache.get<Map<String, dynamic>>(
                    RoutesName.createQuiz,
                    state.extra,
                  )
                  as CreateQuizFormArgs?;
          if (extra == null) return _fallbackHome();

          return BlocProvider(
            create: (_) =>
                CreateQuizCubit(getIt<QuizRepository>())..init(extra),
            child: const CreateQuizView(),
          );
        },
      ),

      GoRoute(
        name: RoutesName.manageQuestions,
        path: RoutesName.manageQuestions,
        builder: (context, state) {
          final extra = RouterPayloadCache.get<Map<String, dynamic>>(
            RoutesName.manageQuestions,
            state.extra,
          );
          if (extra == null) return _fallbackHome();

          return BlocProvider(
            create: (_) => ManageQuizCubit(getIt<QuizRepository>()),
            child: const ManageQuestionsView(),
          );
        },
      ),

      GoRoute(
        name: RoutesName.takeQuiz,
        path: RoutesName.takeQuiz,
        builder: (context, state) {
          final extra = RouterPayloadCache.get<Map<String, dynamic>>(
            RoutesName.takeQuiz,
            state.extra,
          );
          if (extra == null) return _fallbackHome();
          final quizId = extra['quizId'] as String? ?? '';
          final quizTitle = extra['quizTitle'] as String? ?? 'Quiz';

          return BlocProvider(
            create: (_) =>
                TakeQuizCubit(getIt<QuizRepository>())
                  ..fetchQuestionsAndStart(quizId),
            child: TakeQuizView(quizTitle: quizTitle),
          );
        },
      ),

      GoRoute(
        name: RoutesName.submissionsList,
        path: RoutesName.submissionsList,
        builder: (context, state) {
          final extra = RouterPayloadCache.get<Map<String, dynamic>>(
            RoutesName.submissionsList,
            state.extra,
          );
          if (extra == null) return _fallbackHome();
          final quizId = extra['quizId'] as String? ?? '';
          final quizTitle = extra['quizTitle'] as String? ?? 'All Submissions';

          return BlocProvider(
            create: (_) => SubmissionsCubit(getIt<QuizRepository>()),
            child: SubmissionsListView(quizTitle: quizTitle, quizId: quizId),
          );
        },
      ),

      GoRoute(
        name: RoutesName.gradeSubmission,
        path: RoutesName.gradeSubmission,
        builder: (context, state) {
          final extra = RouterPayloadCache.get<Map<String, dynamic>>(
            RoutesName.gradeSubmission,
            state.extra,
          );
          if (extra == null) return _fallbackHome();
          final submissionId = extra['submissionId'] as String? ?? '';

          return BlocProvider(
            create: (_) =>
                GradingCubit(getIt<QuizRepository>())
                  ..loadSubmissionDetails(submissionId),
            child: const GradeSubmissionView(),
          );
        },
      ),
    ],
  );
}
