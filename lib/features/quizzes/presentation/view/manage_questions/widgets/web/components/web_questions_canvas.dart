import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/manage_questions_args.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/empty_state_widget.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/question_card.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/shared_back_button.dart';

class WebQuestionsCanvas extends StatelessWidget {
  final ManageQuestionsArgs args;
  final List<EditableQuestionModel> questions;
  final bool canAddNew;

  final void Function(String type) onAddQuestionBtn;
  final void Function(String localId) onRemove;
  final void Function(
    String localId, {
    String? text,
    int? timeLimit,
    num? points,
  })
  onUpdateField;
  final void Function(String localId, String newType) onChangeType;
  final void Function(String localId) onAddOption;
  final void Function(String localId, String optionId) onRemoveOption;
  final void Function(String localId, String optionId, String newText)
  onUpdateOptionText;
  final void Function(String localId, String optionId) onToggleCorrectOption;

  const WebQuestionsCanvas({
    super.key,
    required this.args,
    required this.questions,
    required this.canAddNew,
    required this.onAddQuestionBtn,
    required this.onRemove,
    required this.onUpdateField,
    required this.onChangeType,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onUpdateOptionText,
    required this.onToggleCorrectOption,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth(context);
    final horizontalPadding = screenWidth < 900 ? 16.0 : 40.0;

    return Container(
      color: const Color(0xFFF8FAFC), // Ultra-clean light background
      child: Column(
        children: [
          // ─── Subtle Canvas Header ───
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              border: const Border(
                bottom: BorderSide(color: AppColors.whiteHover, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SharedBackButton(
                      color: AppColors.primary,
                    ),

                    const Gap(12),

                    Text(
                      'Quiz Questions',
                      style: AppStyles.mobileBodyLargeSb.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),

                if (questions.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${questions.length} Total',
                      style: AppStyles.mobileBodyXsmallMd.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ─── The Questions Area ───
          Expanded(
            child: questions.isEmpty
                ? EmptyStateWidget(
                    onAddFirst: canAddNew
                        ? () => onAddQuestionBtn(ApiValues.mcq)
                        : null,
                  )
                : _buildScrollableList(horizontalPadding),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableList(double padding) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(padding, 32, padding, 100),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QuestionCard(
                  key: ValueKey(question.localId),
                  question: question,
                  mode: args.mode,
                  index: index,
                  onRemove: onRemove,
                  onUpdateField: onUpdateField,
                  onChangeType: onChangeType,
                  onAddOption: onAddOption,
                  onRemoveOption: onRemoveOption,
                  onUpdateOptionText: onUpdateOptionText,
                  onToggleCorrectOption: onToggleCorrectOption,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
