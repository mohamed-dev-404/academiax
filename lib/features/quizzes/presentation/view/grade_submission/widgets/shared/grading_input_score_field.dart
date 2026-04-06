import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/submission_details_model.dart';

class GradingInputScoreField extends StatefulWidget {
  final SubmissionDetailsModel question;
  final Function(num score) onSave;
  final bool isSaving;

  const GradingInputScoreField({
    super.key,
    required this.question,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<GradingInputScoreField> createState() => _GradingInputScoreFieldState();
}

class _GradingInputScoreFieldState extends State<GradingInputScoreField> {
  late final TextEditingController _scoreController;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _scoreController = TextEditingController(text: _initialText);
    _scoreController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _scoreController.removeListener(_onTextChanged);
    _scoreController.dispose();
    super.dispose();
  }

  //! ==================== State Logic ====================

  String get _initialText =>
      widget.question.isGraded ? '${widget.question.earnedPoints}' : '';

  void _onTextChanged() {
    final text = _scoreController.text;
    final isCurrentlyDirty = text != _initialText && text.isNotEmpty;

    if (_isModified != isCurrentlyDirty) {
      setState(() => _isModified = isCurrentlyDirty);
    }
  }

  void _saveScore() {
    final text = _scoreController.text.trim();

    // 1. Validation: Field is empty
    if (text.isEmpty) {
      AppToast.warning(
        context,
        'Empty Field: Please enter a score before saving.',
      );
      return;
    }

    final score = num.tryParse(text);

    if (score != null) {
      // 2. Validation: Score exceeds maximum points
      if (score > widget.question.points) {
        AppToast.warning(
          context,
          'Invalid Score: Value cannot exceed the maximum marks (${widget.question.points}).',
        );
        return;
      }

      // 3. Info: Trying to save while already marked and no changes made
      if (widget.question.isGraded && !_isModified) {
        AppToast.info(
          context,
          'No changes detected. This question is already marked.',
        );
        return;
      }

      // 4. Success: Pass data back up
      widget.onSave(score);
      if (mounted) setState(() => _isModified = false);
    }
  }

  //! ==================== UI Getters ====================

  Color get _statusColor =>
      widget.question.isGraded ? AppColors.primary : StatusColors.orange;

  String get _notchText {
    if (_isModified) return 'UNSAVED';
    if (widget.question.isGraded) {
      return 'MARKED: ${widget.question.earnedPoints}/${widget.question.points}';
    }
    return 'UNMARKED';
  }

  bool get _isUngradedEmpty => !widget.question.isGraded && !_isModified;

  Color get _buttonColor {
    if (_isUngradedEmpty) return Colors.transparent;
    if (widget.question.isGraded) {
      return _isModified
          ? AppColors.primary
          : AppColors.primary.withValues(alpha: 0.1);
    }
    return _isModified
        ? StatusColors.orange
        : AppColors.primary.withValues(alpha: 0.1);
  }

  IconData get _buttonIcon {
    if (widget.question.isGraded) {
      return _isModified ? Icons.sync_rounded : Icons.done_all_rounded;
    }
    return Icons.check_rounded;
  }

  Color get _buttonIconColor {
    if (_isUngradedEmpty) return StatusColors.orange.withValues(alpha: 0.6);
    if (widget.question.isGraded && !_isModified) {
      return AppColors.primary.withValues(alpha: 0.4);
    }
    return AppColors.white;
  }

  //! ==================== Build Methods ====================

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildInputBox(context),
            _buildStatusNotch(),
          ],
        ),
        const SizedBox(width: 8),
        _buildSaveButton(widget.isSaving),
      ],
    );
  }

  Widget _buildInputBox(BuildContext context) {
    return Container(
      width: 95,
      height: 42,
      decoration: BoxDecoration(
        color: widget.question.isGraded
            ? AppColors.primary.withValues(alpha: 0.04)
            : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _statusColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  border: InputBorder.none,
                ),
              ),
              child: AppTextField(
                hintText: widget.question.isGraded
                    ? widget.question.earnedPoints.toString()
                    : widget.question.displayScore,
                controller: _scoreController,
                textFieldType: TextFieldType.numerical,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '/${widget.question.points}',
              style: AppStyles.mobileLabelMediumMd.copyWith(
                color: AppColors.whiteDarkActive.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusNotch() {
    return Positioned(
      top: -15,
      left: 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _statusColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: _statusColor.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          _notchText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isSaving) {
    return GestureDetector(
      onTap: isSaving ? null : _saveScore,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSaving
              ? AppColors.primary.withValues(alpha: 0.1)
              : _buttonColor,
          borderRadius: BorderRadius.circular(14),
          border: _isUngradedEmpty && !isSaving
              ? Border.all(
                  color: StatusColors.orange.withValues(alpha: 0.6),
                  width: 1.5,
                )
              : null,
          boxShadow: _isModified && !isSaving
              ? [
                  BoxShadow(
                    color: _buttonColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: isSaving
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                _buttonIcon,
                color: _buttonIconColor,
                size: 22,
              ),
      ),
    );
  }
}
