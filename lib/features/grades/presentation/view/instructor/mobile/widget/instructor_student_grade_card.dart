import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/grade_column_model.dart';
import 'package:sams_app/features/grades/data/model/instructor_grades/grade_row_model.dart';
import 'package:sams_app/features/grades/presentation/view/widget/mobile/grade_badge.dart';

/// ─── Student Grade Card ───
/// Expandable card showing student info and grade details.
class InstructorStudentGradeCard extends StatefulWidget {
  const InstructorStudentGradeCard({
    super.key,
    required this.row,
    required this.gradeColumns,
  });

  final GradeRowModel row;
  final List<GradeColumnModel> gradeColumns;

  @override
  State<InstructorStudentGradeCard> createState() =>
      _InstructorStudentGradeCardState();
}

class _InstructorStudentGradeCardState extends State<InstructorStudentGradeCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primaryLightActive
              : AppColors.whiteHover,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ─── Card Header ───
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: _isExpanded ? Radius.zero : const Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Student avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        widget.row.student.name
                            .split(' ')
                            .take(2)
                            .map((e) => e[0])
                            .join()
                            .toUpperCase(),
                        style: AppStyles.mobileBodyXsmallMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Student info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.row.student.name,
                          style: AppStyles.mobileBodySmallMd.copyWith(
                            color: AppColors.primaryDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.row.student.academicId,
                          style: AppStyles.mobileBodyXsmallRg.copyWith(
                            color: AppColors.whiteDarkHover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grades summary badge
                  _buildGradesSummary(),
                  const SizedBox(width: 8),

                  // Expand icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.whiteDarkHover,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Expanded Grades List ───
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedGrades(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesSummary() {
    final graded = widget.gradeColumns
        .where((c) => widget.row.grades[c.key] != null)
        .length;
    final total = widget.gradeColumns.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: graded == total
            ? StatusColors.greenTransparent
            : graded == 0
            ? StatusColors.greyTransparent
            : StatusColors.blueTransparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$graded/$total',
        style: AppStyles.mobileBodyXsmallMd.copyWith(
          color: graded == total
              ? StatusColors.greenDark
              : graded == 0
              ? StatusColors.grey
              : StatusColors.blueDark,
        ),
      ),
    );
  }

  Widget _buildExpandedGrades() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        children: [
          const Divider(color: AppColors.whiteHover, height: 1),
          const SizedBox(height: 10),
          ...widget.gradeColumns.map((col) {
            final score = widget.row.grades[col.key];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // Grade name
                  Expanded(
                    flex: 3,
                    child: Text(
                      col.name,
                      style: AppStyles.mobileBodySmallRg.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),

                  // Points label
                  Expanded(
                    flex: 1,
                    child: Text(
                      '/ ${col.points}',
                      style: AppStyles.mobileBodyXsmallRg.copyWith(
                        color: AppColors.whiteDarkHover,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Score
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GradeBadge(
                        score: score,
                        maxScore: col.points ?? 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
