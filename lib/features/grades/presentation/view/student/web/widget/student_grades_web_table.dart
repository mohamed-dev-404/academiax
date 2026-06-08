import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/grades/presentation/view/widget/web/grade_cell.dart';
import 'package:sams_app/features/grades/presentation/view/student/utils/student_grade_ui_extensions.dart';

class StudentGradesWebTable extends StatelessWidget {
  const StudentGradesWebTable({super.key, required this.grades});

  final List<StudentGradeModel> grades;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.whiteHover),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Table header
            _buildTableHeader(),
            // Table rows
            ...grades.asMap().entries.map(
              (entry) => _buildTableRow(entry.value, entry.key),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: AppColors.primary,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Category',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Score',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Max',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: AppStyles.mobileBodySmallMd.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(StudentGradeModel grade, int index) {
    final isVisible = grade.isVisible;
    final isGraded = grade.score != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: !isVisible
            ? StatusColors.redLight
            : index.isEven
            ? AppColors.whiteLight
            : AppColors.white,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.whiteHover,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Category name with icon
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: grade.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    grade.categoryIcon,
                    size: 16..clamp(14, 18),
                    color: grade.categoryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    grade.classwork,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: AppColors.primaryDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Expanded(
            flex: 2,
            child: Center(
              child: isVisible
                  ? GradeCell(
                      score: grade.score,
                      maxScore: grade.maxScore,
                    )
                  : const Icon(
                      Icons.visibility_off_rounded,
                      size: 18,
                      color: StatusColors.redDark,
                    ),
            ),
          ),

          // Max Score
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                grade.formattedMaxScore,
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkHover,
                ),
              ),
            ),
          ),

          // Status badge
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: !isVisible
                      ? StatusColors.redTransparent
                      : isGraded
                      ? StatusColors.greenTransparent
                      : StatusColors.orangeTransparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  !isVisible
                      ? 'Hidden'
                      : isGraded
                      ? 'Graded'
                      : 'Pending',
                  style: AppStyles.mobileBodyXsmallMd.copyWith(
                    color: !isVisible
                        ? StatusColors.redDark
                        : isGraded
                        ? StatusColors.greenDark
                        : StatusColors.orangeDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
