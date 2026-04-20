import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/utils/ui_state_mapper.dart';

/// Left sidebar panel for the web grading layout.
///
/// Shows a progress header with grading stats and a scrollable list
/// of questions for quick navigation.
class QuestionNavigatorPanel extends StatelessWidget {
  final List<StudentSubmissionModel> questions;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const QuestionNavigatorPanel({
    super.key,
    required this.questions,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Count stats
    final total = questions.length;
    final graded = questions
        .where((q) => q.state != QuestionUIState.unmarked)
        .length;
    final pending = total - graded;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        border: Border(
          right: BorderSide(
            color: AppColors.secondaryLightActive.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _NavigatorHeader(
            total: total,
            graded: graded,
            pending: pending,
          ),

          // Question list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: questions.length,
              itemBuilder: (context, index) => _QuestionNavItem(
                question: questions[index],
                index: index,
                isSelected: index == selectedIndex,
                onTap: () => onSelect(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Navigator Header ────────────────────────────────────────────────────────
class _NavigatorHeader extends StatelessWidget {
  final int total;
  final int graded;
  final int pending;

  const _NavigatorHeader({
    required this.total,
    required this.graded,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_turned_in_outlined,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Questions',
                style: AppStyles.webAgBodyBold.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : graded / total,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$graded / $total graded',
                style: AppStyles.webAgBodyRegular.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 11,
                ),
              ),
              _PendingStatusBadge(pending: pending),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pending Status Badge ────────────────────────────────────────────────────
class _PendingStatusBadge extends StatelessWidget {
  final int pending;

  const _PendingStatusBadge({required this.pending});

  @override
  Widget build(BuildContext context) {
    if (pending > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: StatusColors.orange.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.schedule_rounded,
              color: Colors.white,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              '$pending Pending',
              style: AppStyles.webAgBodyBold.copyWith(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: StatusColors.green.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.task_alt_rounded,
              color: Colors.white,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              'All Graded',
              style: AppStyles.webAgBodyBold.copyWith(
                color: Colors.white,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }
  }
}

// ── Single nav row ──────────────────────────────────────────────────────────
class _QuestionNavItem extends StatelessWidget {
  final StudentSubmissionModel question;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuestionNavItem({
    required this.question,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.secondaryLightActive,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: AppStyles.webAgBodyBold.copyWith(
                fontSize: 11,
                color: isSelected ? Colors.white : AppColors.primaryDark,
              ),
            ),
          ),
        ),
        title: Text(
          question.text.length > 40
              ? '${question.text.substring(0, 40)}…'
              : question.text,
          style: AppStyles.webAgBodyRegular.copyWith(
            fontSize: 12,
            color: isSelected ? AppColors.primaryDark : AppColors.whiteDarker,
          ),
          maxLines: 2,
        ),
        trailing: Icon(
          question.state.navDotIcon,
          color: question.state.navDotColor,
          size: 16,
        ),
      ),
    );
  }
}
