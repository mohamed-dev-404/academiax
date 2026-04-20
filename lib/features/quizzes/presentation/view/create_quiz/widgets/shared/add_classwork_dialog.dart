import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';

/// A dialog that lets the instructor create a new classwork item.
///
/// Flow:
///   1. User fills in the name and total marks.
///   2. On "Done" press, calls [CreateQuizCubit.addNewClasswork].
///   3. A [BlocListener] handles the response:
///      • [CreateClassworkLoading] → shows a loading indicator on the button.
///      • [CreateClassworkSuccess] → shows a success toast and closes the dialog.
///      • [CreateClassworkFailure] → shows an error toast (dialog stays open).
class AddClassworkDialog extends StatefulWidget {
  const AddClassworkDialog({super.key});

  /// Shows the dialog with the cubit already available in the widget tree.
  static void show(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AddClassworkDialog(),
      ),
    );
  }

  @override
  State<AddClassworkDialog> createState() => _AddClassworkDialogState();
}

class _AddClassworkDialogState extends State<AddClassworkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final points = num.tryParse(_pointsController.text.trim()) ?? 0;

    context.read<CreateQuizCubit>().addNewClasswork(name, points);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateQuizCubit, CreateQuizState>(
      listener: (context, state) {
        if (state is CreateClassworkSuccess) {
          AppToast.success(context, state.message);
          Navigator.of(context).pop();
        } else if (state is CreateClassworkFailure) {
          AppToast.error(context, state.message);
        }
      },
      child: Dialog(
        backgroundColor: AppColors.whiteLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24), // Spacing to balance the close button
                      Text(
                        'New Classwork',
                        style: AppStyles.mobileTitleSmallSb.copyWith(
                          color: AppColors.primaryDarkHover,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(50),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.whiteDarkHover,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.whiteHover, thickness: 1),
                  const SizedBox(height: 20),

                // ── Name field ──
                TitledInputField(
                  label: 'Classwork Name',
                  child: AppTextField(
                    hintText: 'e.g. Quiz 3',
                    controller: _nameController,
                    textFieldType: TextFieldType.normal,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Points field ──
                TitledInputField(
                  label: 'Total Marks',
                  child: AppTextField(
                    hintText: 'e.g. 5',
                    controller: _pointsController,
                    textFieldType: TextFieldType.decimal,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Submit button (shows loading when saving) ──
                BlocBuilder<CreateQuizCubit, CreateQuizState>(
                  buildWhen: (_, curr) =>
                      curr is CreateClassworkLoading ||
                      curr is CreateClassworkSuccess ||
                      curr is CreateClassworkFailure,
                  builder: (context, state) {
                    final isLoading = state is CreateClassworkLoading;

                    if (isLoading) {
                      return const Center(
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: AppAnimatedLoadingIndicator(),
                        ),
                      );
                    }

                    return AppButton(
                      model: AppButtonStyleModel(
                        label: 'Done',
                        onPressed: _submit,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
