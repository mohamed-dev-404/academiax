import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_state.dart';

class PlagiarismSection extends StatelessWidget {
  const PlagiarismSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAssignmentCubit, CreateAssignmentState>(
      buildWhen: (previous, current) => current is CreateAssignmentUIUpdated,
      builder: (context, state) {
        final cubit = context.read<CreateAssignmentCubit>();

        return Column(
          children: [
            SwitchListTile(
              secondary: Icon(
                Icons.checklist_rounded,
                color: cubit.enablePlagiarism
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: const Text(
                'Enable Plagiarism Check',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Automatically check student submissions for matches',
              ),
              value: cubit.enablePlagiarism,
              onChanged: (value) {
                return cubit.togglePlagiarism(value);
              },
            ),

            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TitledInputField(
                  label: 'Plagiarism Threshold (%)',
                  child: AppTextField(
                    validator: (value) => cubit.validatePlagiarismThreshold(value),
                    prefixIcon: const Icon(Icons.percent),
                    hintText: 'Enter value (e.g. 25)',
                    textFieldType: TextFieldType.numerical,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) =>
                        cubit.updateThreshold(int.parse(value)),
                  ),
                ),
              ),
              crossFadeState: cubit.enablePlagiarism
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        );
      },
    );
  }
}
