import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/grades/presentation/view/instructor/mobile/widget/instructor_student_grade_card.dart';
import 'package:sams_app/features/grades/presentation/view_model/grade_cubit/grade_cubit.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/user_pagination_model.dart';

class InstructorGradesMobileCardsContent extends StatelessWidget {
  const InstructorGradesMobileCardsContent({
    super.key,
    required this.rows,
    required this.filteredCols,
    required this.pagination,
    required this.cubit,
  });

  final List<GradeRowModel> rows;
  final List<GradeColumnModel> filteredCols;
  final UserPaginationModel pagination;
  final GradeCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: GradesEmptyState(
          title: 'No students found',
          subtitle: 'Try a different search query',
        ),
      );
    }

    if (filteredCols.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: GradesEmptyState(
          title: 'No columns to display',
          subtitle: 'Adjust your visibility filter or toggle columns',
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          itemCount: rows.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return InstructorStudentGradeCard(
              row: rows[index],
              gradeColumns: filteredCols,
            );
          },
        ),
        // ─── Pagination Controls (Load More / Page Navigation) ───
        if (pagination.hasNextPage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: OutlinedButton(
              onPressed: () => cubit.onPageChanged(cubit.currentPage + 1),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Next Page',
                style: AppStyles.mobileBodySmallMd,
              ),
            ),
          ),
        if (pagination.hasPrevPage)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: OutlinedButton(
              onPressed: () => cubit.onPageChanged(cubit.currentPage - 1),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.whiteDarkHover,
                side: const BorderSide(color: AppColors.whiteDarkHover),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Previous Page',
                style: AppStyles.mobileBodySmallMd,
              ),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
