import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/choice_question_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/written_question_model.dart';

import 'choice_question_widget.dart';
import 'written_question_widget.dart';

class QuizQuestionCard extends StatelessWidget {
  final int questionIndex;
  final QuestionModel question;
  final String? selectedAnswerId; // For MCQ/TF
  final TextEditingController? writtenAnswerController; // For Written
  final Function(String) onAnswerChanged; // For both MCQ/TF and Written

  const QuizQuestionCard({
    super.key,
    required this.questionIndex,
    required this.question,
    this.selectedAnswerId,
    this.writtenAnswerController,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text with Index
          Text(
            '$questionIndex-${question.text}',
            style: AppStyles.mobileLabelMediumMd.copyWith(
              color: AppColors.primaryDarkActive,
            ),
          ),
          const SizedBox(height: 24),

          // Factory-like rendering based on Question Type
          _buildQuestionContent(),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    if (question is ChoiceQuestionModel) {
      return ChoiceQuestionWidget(
        question: question as ChoiceQuestionModel,
        selectedOptionId: selectedAnswerId,
        onSelect: onAnswerChanged,
      );
    } else if (question is WrittenQuestionModel) {
      return WrittenQuestionWidget(
        controller: writtenAnswerController,
        onChanged: onAnswerChanged,
      );
    }
    return const SizedBox.shrink();
  }
}
