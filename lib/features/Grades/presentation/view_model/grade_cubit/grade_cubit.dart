import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/features/Grades/data/model/instructor_grades/grade_response_model.dart';
import 'package:sams_app/features/Grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/Grades/data/repos/grade_repo.dart';

part 'grade_state.dart';

class GradeCubit extends Cubit<GradeState> {
  GradeCubit(this._repo) : super(GradeInitial());
  // ignore: unused_field
  final GradeRepo _repo;

  //? This variable will hold the course ID for which grades are being managed.
  // It will updated when call getGrades() method with the courseId parameter.
  String storedCourseId = '';

  //? This list will hold the grades data for students.
  //It can be updated when fetching grades from the repository.
  List<StudentGradeModel> studentGrades = [];

  //? This variable will hold the grades data for instructors.
  // It can be updated when fetching grades from the repository.
  GradeResponseModel? instructorGrades;

  //? Pagination and search state variables for managing grade data retrieval.
  int currentPage = 1;
  int perPage = 10;
  TextEditingController searchController = TextEditingController();

  ///* Fetches grades based on the current user's role (instructor or student).
  Future<void> getGrades({required String courseId}) async {
    // Store the course ID for later use (e.g., toggling visibility)
    storedCourseId = courseId;

    // Implement logic to load grades according to the user role (instructor or student)
    if (CurrentRole.role == UserRole.instructor) {
      getGradesForInstructor();
    } else if (CurrentRole.role == UserRole.student) {
      getGradesForStudent();
    }
  }

  //* Fetches grades for instructors.
  Future<void> getGradesForInstructor() async {
    if (instructorGrades == null) {
      emit(GradeLoading());
    } else {
      emit(GradeTableLoading());
    }

    var result = await _repo.getAllGrades(
      courseId: storedCourseId,
      page: currentPage,
      perPage: perPage,
      search: searchController.text,
    );

    result.fold(
      (failure) => emit(GradeLoadingFailed(failure)),
      (gradesData) {
        instructorGrades = gradesData;
        emit(GradeLoadedSuccessfully());
      },
    );
  }

  /// Called from UI when the user triggers a search (search icon tap / submit).
  void onSearch() {
    currentPage = 1; // reset to first page on new search
    getGradesForInstructor();
  }

  /// Called from UI when the user changes the current page.
  void onPageChanged(int page) {
    currentPage = page;
    getGradesForInstructor();
  }

  /// Called from UI when the user changes page size (rows per page).
  void onPageSizeChanged(int size) {
    perPage = size;
    currentPage = 1; // reset to first page on page size change
    getGradesForInstructor();
  }

  //* Toggles the visibility of classwork grades for instructors.
  Future<void> toggleClassworkVisiability({required String classworkId}) async {
    var result = await _repo.toggleClassworkVisibility(
      courseId: storedCourseId,
      classworkId: classworkId,
    );
    result.fold(
      (failureMessage) => emit(ToggleClassworkVisibilityFailed(failureMessage)),
      (_) => emit(ToggleClassworkVisibilitySuccess()),
    );
  }

  //* Fetches grades for students.
  Future<void> getGradesForStudent() async {
    // Implement logic to load grades for the student
  }
}
