import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/student_submission_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/grade_submission/utils/ui_state_mapper.dart';

class McqOptionsList extends StatelessWidget {
  final List<AnswerOptionModel> options;

  const McqOptionsList({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _McqOptionItem(option: options[index]),
    );
  }
}

// ─── Private widget — one option row ─────────────────────────────────────────
class _McqOptionItem extends StatelessWidget {
  final AnswerOptionModel option;

  const _McqOptionItem({required this.option});

  @override
  Widget build(BuildContext context) {
    // 2. Build the option container
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: option.state.tileBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: option.state.tileBorderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              option.text,
              style: AppStyles.mobileBodyMediumRg.copyWith(
                color: option.state.textContentColor,
                fontWeight: option.state.isBoldText
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
          if (option.state.trailingIcon != null)
            Icon(
              option.state.trailingIcon,
              color: option.state.trailingIconColor,
              size: 20,
            ),
        ],
      ),
    );
  }
}
