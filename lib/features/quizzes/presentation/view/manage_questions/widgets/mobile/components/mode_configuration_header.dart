import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/utils/manage_questions_ui_utils.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/shared_back_button.dart';

/// Displays the screen title and subtitle based on the current [QuizMode].
///
/// If [quizTitle] is provided, it replaces the main heading for a more personalized
/// experience, and moves the standard mode text to the subtitle.
class ModeConfigurationHeader extends StatelessWidget {
  final QuizMode mode;
  final int questionCount;
  final String quizTitle;

  const ModeConfigurationHeader({
    super.key,
    required this.mode,
    this.questionCount = 0,
    required this.quizTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Back Button + Mode Badge ───
            Row(
              children: [
                const SharedBackButton(),
                const SizedBox(width: 12),
                _buildModeBadge(),
              ],
            ),
            const SizedBox(height: 16),

            // ─── Main Title (Quiz Title) ───
            Text(
              quizTitle,
              style: AppStyles.mobileTitleMediumSb.copyWith(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // ─── Metadata Row (Mode Action • Question Count) ───
            Row(
              children: [
                Text(
                  ManageQuestionsUiUtils.getHeaderTitle(mode),
                  style: AppStyles.mobileBodySmallRg.copyWith(
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                if (questionCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$questionCount question${questionCount == 1 ? '' : 's'}',
                    style: AppStyles.mobileBodyXsmallMd.copyWith(
                      color: AppColors.secondaryLightHover,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── Subwidgets ────────────

  Widget _buildModeBadge() {
    final badgeColor = ManageQuestionsUiUtils.getBadgeColor(mode);
    final badgeLabel = ManageQuestionsUiUtils.getBadgeLabel(mode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withAlpha(100), width: 1),
      ),
      child: Text(
        badgeLabel,
        style: AppStyles.mobileBodyXsmallMd.copyWith(color: badgeColor),
      ),
    );
  }
}
