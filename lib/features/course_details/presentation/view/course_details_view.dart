import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/Grades/presentation/view/grades_tab_view.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_tab_view/announcements_tab_view.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view/assignments_tab_view.dart';
import 'package:sams_app/features/course_code/presentation/view/course_code_tab_view.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/mobile/tab_bar_mobile_layout.dart';
import 'package:sams_app/features/course_details/presentation/view/widget/web/tab_bar_web_layout.dart';
import 'package:sams_app/features/course_details/presentation/view_models/course_navigation/course_navigation_cubit.dart';
import 'package:sams_app/features/live_sessions/presentation/view/live_sessions_tab_view.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/materials_tab_view.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
import 'package:sams_app/features/members_list/presentation/view/members_list_tab_view.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/quizzes_tab_view.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/get_all_quizes_cubit/get_all_quizes_cubit.dart';

class CourseDetailsView extends StatelessWidget {
  const CourseDetailsView({super.key, required this.courseModel});

  final CourseHeaderCardModel courseModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseNavigationCubit(
        userRole: CurrentRole.role,
        courseModel: courseModel,
      ),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CourseNavigationCubit>();
          final tabs = _buildTabs(courseModel.courseId, cubit);
          return AdaptiveLayout(
            mobileLayout: (_) => TabBarMobileLayout(tabs: tabs),
            webLayout: (_) => TabBarWebLayout(tabs: tabs),
          );
        },
      ),
    );
  }

  /// Builds the ordered list of tab widgets that matches [cubit.visibleTabs].
  /// Each tab is a self-contained widget; they can read CourseNavigationCubit
  /// from context to access courseModel / courseId if needed.
  List<Widget> _buildTabs(String courseId, CourseNavigationCubit cubit) {
    final allTabs = <String, Widget>{
      //* Materials
      'Materials': MultiBlocProvider(
        providers: [
          //* 1. Fetch Cubit: Responsible for loading the list of materials.
          //* Triggering the initial fetch immediately upon creation.
          BlocProvider(
            create: (context) =>
                getIt<MaterialFetchCubit>()..fetchMaterials(courseId: courseId),
          ),
          //* 2. CRUD Cubit: Responsible for operations like adding or deleting materials.
          BlocProvider(
            create: (context) => getIt<MaterialCrudCubit>(),
          ),
        ],
        child: MaterialsTabView(courseId: courseId),
      ),

      'Assignments': AssignmentsTabView(courseId: courseId),
       
       //* Announcements 
      'Announcements': BlocProvider(
        create: (context) => getIt<AnnouncementsFetchCubit>()..fetchAnnouncements(courseId: courseId),
        child: AnnouncementsTabView(courseId: courseId),
      ),

      'Grades': GradesTabView(courseId: courseId),
       
       //* Quizzes 
      'Quizzes': BlocProvider(
        create: (_) =>
            GetAllQuizesCubit(getIt<QuizRepository>())
              ..getCourseQuizzes(courseId: courseId),
        child: QuizzesTabView(courseId: courseId),
      ),

      'Live Sessions': LiveSessionsTabView(courseId: courseId),

      'Course Code': CourseCodeTabView(courseId: courseId),

      'Members List': MembersListTabView(courseId: courseId),
    };

    // Return only the tabs that are visible for the current role,
    // preserving the same order the cubit uses.
    return cubit.visibleTabs.map((tab) => allTabs[tab.title]!).toList();
  }
}
