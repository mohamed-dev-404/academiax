class CourseHeaderCardModel {
  final String courseId;
  final String title;
  final String? description;
  final String? instructor;

  const CourseHeaderCardModel({
    required this.courseId,
    required this.title,
    this.description,
    this.instructor,
  });
}
