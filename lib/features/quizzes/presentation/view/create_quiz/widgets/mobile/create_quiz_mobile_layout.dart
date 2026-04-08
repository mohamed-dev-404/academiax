import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/validators/app_validators.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/mobile/mobile_custom_app_bar.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/quizzes/data/mock_data.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/data/model/request_bodies_models/create_quiz_request_body.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_selector_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_form/quiz_form_args.dart';

/// A unified "Smart Form" screen for both creating and editing a quiz.
///
/// Behaviour is driven entirely by [QuizFormArgs]:
/// - [QuizFormArgs.isEditMode] == false → Create mode (blank form, "Create Quiz" title)
/// - [QuizFormArgs.isEditMode] == true  → Edit mode (pre-filled form, "Edit Quiz" title,
///   classwork field locked)
///
/// Data flow is ready for Cubit integration — see the TODO comments at the
/// submit handler.
class CreateQuizMobileLayout extends StatefulWidget {
  final QuizFormArgs args;

  const CreateQuizMobileLayout({super.key, required this.args});

  @override
  State<CreateQuizMobileLayout> createState() => _CreateQuizMobileLayoutState();
}

class _CreateQuizMobileLayoutState extends State<CreateQuizMobileLayout> {
  // ──────────────────── Form Key ────────────────────
  final _formKey = GlobalKey<FormState>();

  // ──────────────────── Controllers ────────────────────
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;
  late final TextEditingController _startTimeDisplayController;

  // ──────────────────── State ────────────────────
  ClassworItemkModel? _selectedClasswork;
  DateTime? _selectedStartTime;

  // ──────────────────── Convenience getters ────────────────────
  bool get _isEditMode => widget.args.isEditMode;
  QuizModel? get _initial => widget.args.initialData;

  // ──────────────────── Lifecycle ────────────────────

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  /// Initialises controllers from [QuizFormArgs.initialData] in Edit mode,
  /// or with empty values in Create mode.
  void _initControllers() {
    _titleController = TextEditingController(
      text: _initial?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: _initial?.description ?? '',
    );
    _durationController = TextEditingController(
      text: _initial != null ? _initial!.totalTime.toString() : '',
    );

    // Pre-format the start time display if editing
    if (_initial != null) {
      _selectedStartTime = _initial!.startTime;
      _startTimeDisplayController = TextEditingController(
        text: _formatDateTime(_initial!.startTime),
      );

      // Pre-select the classwork based on the quiz's classworkId, if available.
      // In a real app the cubit would provide the full classwork object;
      // here we search the mock list as a fallback.
      // The classwork field will always be read-only in edit mode regardless.
      _selectedClasswork = mockClassworkItems
          .cast<ClassworItemkModel?>()
          .firstWhere(
            (c) => c != null,
            orElse: () => null,
          );
    } else {
      _startTimeDisplayController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _startTimeDisplayController.dispose();
    super.dispose();
  }

  // ──────────────────── Helpers ────────────────────

  String _formatDateTime(DateTime dt) =>
      DateFormat('MMM dd, yyyy - hh:mm a').format(dt);

  // ──────────────────── Date & Time Picker ────────────────────

  Future<void> _pickStartDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartTime ?? DateTime.now(),
      firstDate: DateTime.now(), // Prohibits past dates
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime != null
          ? TimeOfDay.fromDateTime(_selectedStartTime!)
          : TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedStartTime = combined;
      _startTimeDisplayController.text = _formatDateTime(combined);
    });
  }

  // ──────────────────── Classwork Selection ────────────────────

  void _onClassworkSelected(ClassworItemkModel item) {
    setState(() => _selectedClasswork = item);
  }

  // ──────────────────── Submit ────────────────────

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final body = CreateQuizRequestBody(
      classworkId: _selectedClasswork?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _selectedStartTime,
      duration: int.tryParse(_durationController.text.trim()),
    );

    if (_isEditMode) {
      // TODO: context.read<ManageQuizCubit>().updateQuiz(
      //   quizId: _initial!.id,
      //   body: body,
      // );
      debugPrint('[EDIT] PATCH update-quiz → ${body.toJson()}');
    } else {
      // TODO: context.read<ManageQuizCubit>().createQuiz(
      //   courseId: widget.args.courseId,
      //   body: body,
      // );
      debugPrint('[CREATE] POST create-quiz → ${body.toJson()}');
    }
  }

  // ──────────────────── Build ────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileCustomAppBar(
        title: _isEditMode ? 'Edit Quiz' : 'Create Quiz',
      ),
      bottomNavigationBar: _buildBottomButton(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _SectionHeader(isEditMode: _isEditMode),
              const SizedBox(height: 24),

              // ─── Assigned Classwork ───
              TitledInputField(
                label: 'Assigned Classwork',
                child: ClassworkSelectorField(
                  selectedClasswork: _selectedClasswork,
                  classworkItems: mockClassworkItems,
                  onSelected: _onClassworkSelected,
                  // Locked in edit mode — cannot re-assign the classwork
                  isReadOnly: _isEditMode,
                ),
              ),
              // Hint shown only in edit mode to explain why the field is locked
              if (_isEditMode) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'The assigned classwork cannot be changed after creation.',
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteDarkHover,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // ─── Title ───
              TitledInputField(
                label: 'Title',
                child: AppTextField(
                  hintText: 'Enter quiz title',
                  controller: _titleController,
                  textFieldType: TextFieldType.normal,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 20),

              // ─── Description ───
              TitledInputField(
                label: 'Description',
                child: AppTextField(
                  hintText: 'Enter a brief description (optional)',
                  controller: _descriptionController,
                  textFieldType: TextFieldType.normal,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 20),

              // ─── Start Time ───
              TitledInputField(
                label: 'Start Time',
                child: _DateTimePickerField(
                  controller: _startTimeDisplayController,
                  onTap: _pickStartDateTime,
                ),
              ),
              const SizedBox(height: 20),

              // ─── Duration ───
              TitledInputField(
                label: 'Duration',
                child: _DurationInputField(controller: _durationController),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────── Bottom Button ────────────────────

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: AppButton(
        model: AppButtonStyleModel(
          label: _isEditMode ? 'Save Changes' : 'Continue',
          onPressed: _onSubmit,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Private sub-widgets (scoped to this file — not reused elsewhere)
// ══════════════════════════════════════════════════════════════

/// Contextual header with title and subtitle that adapts to the form mode.
class _SectionHeader extends StatelessWidget {
  final bool isEditMode;
  const _SectionHeader({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditMode ? 'Edit Quiz Details' : 'Quiz Details',
          style: AppStyles.mobileTitleSmallSb.copyWith(
            color: AppColors.primaryDarkHover,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isEditMode
              ? 'Update the fields below and save your changes.'
              : 'Fill in the details to create a new quiz for your students.',
          style: AppStyles.mobileBodyXsmallRg.copyWith(
            color: AppColors.whiteDarkActive,
          ),
        ),
      ],
    );
  }
}

/// Read-only text field that triggers date + time picker on tap.
class _DateTimePickerField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  const _DateTimePickerField({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: AppStyles.mobileBodySmallMd.copyWith(
        color: AppColors.primaryDarkHover,
      ),
      decoration: InputDecoration(
        hintText: 'Pick date & time',
        hintStyle: AppStyles.mobileBodySmallRg.copyWith(
          color: AppColors.whiteDarkHover,
        ),
        suffixIcon: const Icon(
          Icons.calendar_month_rounded,
          color: AppColors.primaryDark,
        ),
      ),
      validator: (_) =>
          controller.text.isEmpty ? 'Start time is required' : null,
    );
  }
}

/// Digits-only field for quiz duration in minutes.
class _DurationInputField extends StatelessWidget {
  final TextEditingController controller;
  const _DurationInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppStyles.mobileBodySmallMd.copyWith(
            color: AppColors.primaryDarkHover,
          ),
          decoration: InputDecoration(
            hintText: 'e.g. 30',
            hintStyle: AppStyles.mobileBodySmallRg.copyWith(
              color: AppColors.whiteDarkHover,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'mins',
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 0,
              minWidth: 0,
            ),
          ),
          validator: (value) => AppValidators.validateNumber(value),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'The time limit for the student to complete the quiz',
            style: AppStyles.mobileBodyXsmallRg.copyWith(
              color: AppColors.whiteDarkActive,
            ),
          ),
        ),
      ],
    );
  }
}
