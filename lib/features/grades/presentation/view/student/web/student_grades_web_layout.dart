import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/grades/presentation/view/student/web/widget/grades_summary_row.dart';
import 'package:sams_app/features/grades/presentation/view/student/web/widget/student_grades_web_table.dart';
import 'package:sams_app/features/grades/presentation/view_model/grade_cubit/grade_cubit.dart';

/// ═══════════════════════════════════════════════════════════════
/// STUDENT — WEB LAYOUT
/// Table/grid-based view of the student's own grades for web.
/// Same data as mobile but in a wider, more spacious layout.
/// ═══════════════════════════════════════════════════════════════
class StudentGradesWebLayout extends StatelessWidget {
  const StudentGradesWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeCubit, GradeState>(
      buildWhen: (previous, current) =>
          current is GradeLoading ||
          current is GradeLoadedSuccessfully ||
          current is GradeLoadingFailed,
      builder: (context, state) {
        // ─── Loading State ───
        if (state is GradeLoading) {
          return const Center(child: AppAnimatedLoadingIndicator());
        }

        // ─── Error State ───
        if (state is GradeLoadingFailed) {
          return Center(
            child: GradesEmptyState(
              title: 'Failed to load grades',
              subtitle: state.errorMessage,
              icon: Icons.error_outline_rounded,
            ),
          );
        }

        // ─── Success State ───
        final allGrades = context.read<GradeCubit>().studentGrades;

        if (allGrades.isEmpty) {
          return const SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradesEmptyState(
                  title: 'No grades available',
                  subtitle: 'Your grades will appear here once published',
                  icon: Icons.assignment_outlined,
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Title ───
                Text(
                  'My Grades',
                  style: AppStyles.mobileTitleMediumSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Summary Row ───
                GradesSummaryRow(allGrades: allGrades),
                const SizedBox(height: 24),

                // ─── Grades Table ───
                StudentGradesWebTable(grades: allGrades),
              ],
            ),
          ),
        );
      },
    );
  }
}
