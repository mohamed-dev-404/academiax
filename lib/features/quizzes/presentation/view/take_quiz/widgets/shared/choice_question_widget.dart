import 'package:flutter/material.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/question/choice_question_model.dart';
import 'option_tile.dart';

class ChoiceQuestionWidget extends StatelessWidget {
  final ChoiceQuestionModel question;
  final String? selectedOptionId;
  final Function(String) onSelect;

  const ChoiceQuestionWidget({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final isSelected = selectedOptionId == option.id;
        
        // Generates 'a', 'b', 'c', 'd' based on index
        final prefixLetter = String.fromCharCode(97 + index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: OptionTile(
            text: option.text,
            prefix: '$prefixLetter) ',
            isSelected: isSelected,
            onTap: () => onSelect(option.id),
          ),
        );
      }),
    );
  }
}