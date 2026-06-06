// ignore_for_file: unintended_html_in_doc_comment
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';

/// A single tab definition — title only (no path, navigation via index).
class CourseTabItem {
  final String title;
  const CourseTabItem({required this.title});
}

/// Drives the tab index for CourseDetailsView.
/// State is the current tab index (int).
/// courseModel is accessible by all tabs via context.read<CourseNavigationCubit>().
class CourseNavigationCubit extends Cubit<int> {
  final UserRole userRole;
  final CourseHeaderCardModel courseModel;

  CourseNavigationCubit({
    required this.userRole,
    required this.courseModel,
  }) : super(0);

  void changeTab(int index) => emit(index);

  final List<CourseTabItem> _allTabs = const [
    CourseTabItem(title: 'Materials'),
    CourseTabItem(title: 'Assignments'),
    CourseTabItem(title: 'Announcements'),
    CourseTabItem(title: 'Grades'),
    CourseTabItem(title: 'Quizzes'),
    CourseTabItem(title: 'Live Sessions'),
    // CourseTabItem(title: 'Course Code'),
    // CourseTabItem(title: 'Members List'),
  ];

  List<CourseTabItem> get visibleTabs {
    return _allTabs;
  }

  List<String> get visibleTabTitles => visibleTabs.map((t) => t.title).toList();

  /// Convenience: the courseId from the model
  String get courseId => courseModel.courseId;
}
