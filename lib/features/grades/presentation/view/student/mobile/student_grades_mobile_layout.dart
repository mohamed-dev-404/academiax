import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/grades/data/model/student_grades/student_grade_model.dart';
import 'package:sams_app/features/grades/presentation/view/widget/shared/grades_empty_state.dart';
import 'package:sams_app/features/grades/presentation/view/student/utils/student_grade_ui_extensions.dart';
import 'package:sams_app/features/grades/presentation/view/widget/mobile/grade_badge.dart';
import 'package:sams_app/features/grades/presentation/view_model/grade_cubit/grade_cubit.dart';

/// ═══════════════════════════════════════════════════════════════
/// STUDENT — MOBILE LAYOUT
/// Simple card-based list showing the student's own grades.
/// Only renders visible items (isVisible == true).
/// ═══════════════════════════════════════════════════════════════
class StudentGradesMobileLayout extends StatelessWidget {
  const StudentGradesMobileLayout({super.key});

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
          return const GradesEmptyState(
            title: 'No grades available',
            subtitle: 'Your grades will appear here once published',
            icon: Icons.assignment_outlined,
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'My Grades',
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),

              // ─── Summary Card ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: _GradesSummaryCard(grades: allGrades),
              ),

              // ─── Grades List ───
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allGrades.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _StudentGradeItem(grade: allGrades[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ─── Summary Card ───
/// Shows overall graded count and total points at a glance.
class _GradesSummaryCard extends StatelessWidget {
  const _GradesSummaryCard({required this.grades});
  final List<StudentGradeModel> grades;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryHover,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Graded count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Graded',
                  style: AppStyles.mobileBodyXsmallRg.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grades.formattedGradedCountText,
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 16),

          // Right: Total score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Score',
                  style: AppStyles.mobileBodyXsmallRg.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grades.formattedTotalScoreFractionText,
                  style: AppStyles.mobileTitleSmallSb.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── Single Grade Item Card ───
class _StudentGradeItem extends StatelessWidget {
  const _StudentGradeItem({required this.grade});
  final StudentGradeModel grade;

  @override
  Widget build(BuildContext context) {
    final isVisible = grade.isVisible;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isVisible
            ? AppColors.whiteLight
            : StatusColors.redLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isVisible
              ? AppColors.primaryLightActive
              : StatusColors.redDark.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Content wrapper for fading invisible item contents
          Expanded(
            child: Row(
              children: [
                // Category icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: grade.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    grade.categoryIcon,
                    size: 18,
                    color: grade.categoryColor,
                  ),
                ),
                const SizedBox(width: 12),

                // Classwork name & Max score
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grade.classwork,
                        style: AppStyles.mobileBodySmallMd.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Max: ${grade.formattedMaxScore}',
                        style: AppStyles.mobileBodyXsmallRg.copyWith(
                          color: AppColors.whiteDarkHover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Score badge or custom Premium Hidden Badge
          if (isVisible)
            GradeBadge(
              score: grade.score,
              maxScore: grade.maxScore,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: StatusColors.redTransparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.visibility_off_rounded,
                    size: 14,
                    color: StatusColors.redDark,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Hidden',
                    style: AppStyles.mobileBodyXsmallMd.copyWith(
                      color: StatusColors.redDark,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
