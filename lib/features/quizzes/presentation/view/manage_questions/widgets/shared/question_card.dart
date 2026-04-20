import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/editable_question_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/model/quiz_mode.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/add_option_button.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/editable_option_tile.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/points_time_row.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/question_text_field.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/question_type_selector.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/read_only_option_tile.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/widgets/shared/true_false_toggle.dart';
import 'package:sams_app/features/quizzes/presentation/view/manage_questions/utils/manage_questions_ui_utils.dart';

/// The main question card widget — a [StatefulWidget] that manages
/// local [TextEditingController]s and [FocusNode]s.
///
/// Receives its data from [EditableQuestionModel] via the parent
/// [BlocBuilder]. Syncs back to the Cubit on focus-loss events.
class QuestionCard extends StatefulWidget {
  final EditableQuestionModel question;
  final QuizMode mode;
  final int index;

  // ──────────── Callbacks (to Cubit) ────────────
  final void Function(String localId) onRemove;
  final void Function(
    String localId, {
    String? text,
    int? timeLimit,
    num? points,
  })
  onUpdateField;
  final void Function(String localId, String newType) onChangeType;
  final void Function(String questionLocalId) onAddOption;
  final void Function(String questionLocalId, String optionLocalId)
  onRemoveOption;
  final void Function(String questionLocalId, String optionLocalId, String text)
  onUpdateOptionText;
  final void Function(String questionLocalId, String optionLocalId)
  onToggleCorrectOption;

  const QuestionCard({
    super.key,
    required this.question,
    required this.mode,
    required this.index,
    required this.onRemove,
    required this.onUpdateField,
    required this.onChangeType,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onUpdateOptionText,
    required this.onToggleCorrectOption,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  // ──────────── Local Controllers ────────────
  late TextEditingController _textController;
  late TextEditingController _pointsController;
  late TextEditingController _timeLimitController;
  bool _isExpanded = true;

  /// Option controllers, keyed by option localId.
  final Map<String, TextEditingController> _optionControllers = {};

  bool get _isReadOnly => widget.mode == QuizMode.view;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync controllers only if the value has changed externally (from Cubit)
    // and is different from what's currently in the controller.
    if (widget.question.text != oldWidget.question.text &&
        widget.question.text != _textController.text) {
      _textController.text = widget.question.text;
    }

    if (widget.question.points != oldWidget.question.points) {
      final currentPointsVal = num.tryParse(_pointsController.text);
      if (currentPointsVal != widget.question.points) {
        // Only force an update if the underlying mathematical value actually changed from the outside.
        // This prevents erasing trailing dots (e.g. "1.") while the user is typing.
        _pointsController.text = widget.question.points.toString();
      }
    }

    if (widget.question.timeLimit != oldWidget.question.timeLimit) {
      final currentTimeVal = int.tryParse(_timeLimitController.text);
      if (currentTimeVal != widget.question.timeLimit) {
        _timeLimitController.text = widget.question.timeLimit.toString();
      }
    }

    // Sync option controllers
    _syncOptionControllers();
  }

  void _initControllers() {
    _textController = TextEditingController(text: widget.question.text);
    _pointsController = TextEditingController(
      text: widget.question.points.toString(),
    );
    _timeLimitController = TextEditingController(
      text: widget.question.timeLimit.toString(),
    );
    _syncOptionControllers();
  }

  void _syncOptionControllers() {
    // Remove controllers for deleted options
    final activeIds = widget.question.options.map((o) => o.localId).toSet();
    _optionControllers.removeWhere((key, controller) {
      if (!activeIds.contains(key)) {
        controller.dispose();
        return true;
      }
      return false;
    });

    // Sync controllers for existing options
    for (final option in widget.question.options) {
      if (_optionControllers.containsKey(option.localId)) {
        final ctrl = _optionControllers[option.localId]!;
        if (ctrl.text != option.text) {
          ctrl.text = option.text;
        }
      } else {
        // Add controllers for new options
        _optionControllers[option.localId] = TextEditingController(
          text: option.text,
        );
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _pointsController.dispose();
    _timeLimitController.dispose();
    for (final c in _optionControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ──────────── Focus-Loss Sync ────────────

  void _syncTextToCubit(String val) {
    widget.onUpdateField(widget.question.localId, text: val);
  }

  void _syncPointsToCubit() {
    final val = num.tryParse(_pointsController.text);
    if (val != null) {
      widget.onUpdateField(widget.question.localId, points: val);
    }
  }

  void _syncTimeLimitToCubit() {
    final val = int.tryParse(_timeLimitController.text);
    if (val != null) {
      widget.onUpdateField(widget.question.localId, timeLimit: val);
    }
  }

  void _syncOptionTextToCubit(String optionLocalId, String text) {
    widget.onUpdateOptionText(
      widget.question.localId,
      optionLocalId,
      text,
    );
  }

  // ──────────── Build ────────────

  @override
  Widget build(BuildContext context) {
    final q = widget.question;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primaryLightActive
              : AppColors.whiteHover,
          width: 1,
        ),
        boxShadow: [
          if (_isExpanded)
            BoxShadow(
              color: AppColors.primary.withAlpha(15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          else
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(q),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildBody(q),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  // ──────────── Header ────────────

  Widget _buildHeader(EditableQuestionModel q) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // ─── Question Number Badge ───
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: AppStyles.mobileBodySmallMd.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ─── Question Type Label ───
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ManageQuestionsUiUtils.getQuestionTypeLabel(q.questionType),
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  if (!_isExpanded && q.text.isNotEmpty)
                    Text(
                      q.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.mobileBodyXsmallRg.copyWith(
                        color: AppColors.whiteDarkActive,
                      ),
                    ),
                ],
              ),
            ),

            // ─── Points Badge ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryLightActive.withAlpha(60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${q.points} pts',
                style: AppStyles.mobileBodyXsmallMd.copyWith(
                  color: AppColors.secondaryDark,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // ─── Delete Button ───
            if (!_isReadOnly)
              GestureDetector(
                onTap: () => widget.onRemove(q.localId),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.redLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: AppColors.red,
                  ),
                ),
              ),

            const SizedBox(width: 4),

            // ─── Expand/Collapse ───
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.whiteDarkHover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── Body ────────────

  Widget _buildBody(EditableQuestionModel q) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.whiteHover),
          const SizedBox(height: 16),

          // ─── Question Type Selector ───
          if (!_isReadOnly) ...[
            Text(
              'Question Type',
              style: AppStyles.mobileBodyXsmallMd.copyWith(
                color: AppColors.whiteDarker,
              ),
            ),
            const SizedBox(height: 8),
            QuestionTypeSelector(
              selectedType: q.questionType,
              enabled: !_isReadOnly,
              onChanged: (type) => widget.onChangeType(q.localId, type),
            ),
            const SizedBox(height: 16),
          ],

          // ─── Question Text ───
          Text(
            'Question Text',
            style: AppStyles.mobileBodyXsmallMd.copyWith(
              color: AppColors.whiteDarker,
            ),
          ),
          const SizedBox(height: 8),
          QuestionTextField(
            controller: _textController,
            enabled: !_isReadOnly,
            onChanged: _syncTextToCubit,
          ),
          const SizedBox(height: 16),

          // ─── Points & Time ───
          PointsTimeRow(
            pointsController: _pointsController,
            timeLimitController: _timeLimitController,
            enabled: !_isReadOnly,
            onPointsChanged: (val) => _syncPointsToCubit(),
            onTimeLimitChanged: (val) => _syncTimeLimitToCubit(),
          ),
          const SizedBox(height: 16),

          // ─── Options Section ───
          _buildOptionsSection(q),
        ],
      ),
    );
  }

  // ──────────── Options Section ────────────

  Widget _buildOptionsSection(EditableQuestionModel q) {
    if (q.isWritten) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.isTrueFalse ? 'Correct Answer' : 'Options',
          style: AppStyles.mobileBodyXsmallMd.copyWith(
            color: AppColors.whiteDarker,
          ),
        ),
        const SizedBox(height: 8),

        if (q.isTrueFalse) _buildTrueFalseSection(q) else _buildMcqSection(q),
      ],
    );
  }

  Widget _buildTrueFalseSection(EditableQuestionModel q) {
    final correctIndex = q.options.indexWhere((o) => o.isCorrect);

    if (_isReadOnly) {
      return Column(
        children: q.options.asMap().entries.map((entry) {
          return ReadOnlyOptionTile(
            text: entry.value.text,
            isCorrect: entry.value.isCorrect,
            index: entry.key,
          );
        }).toList(),
      );
    }

    return TrueFalseToggle(
      correctIndex: correctIndex == -1 ? 0 : correctIndex,
      enabled: !_isReadOnly,
      onChanged: (index) {
        final option = q.options[index];
        widget.onToggleCorrectOption(q.localId, option.localId);
      },
    );
  }

  Widget _buildMcqSection(EditableQuestionModel q) {
    if (_isReadOnly) {
      return Column(
        children: q.options.asMap().entries.map((entry) {
          return ReadOnlyOptionTile(
            text: entry.value.text,
            isCorrect: entry.value.isCorrect,
            index: entry.key,
          );
        }).toList(),
      );
    }

    return Column(
      children: [
        ...q.options.asMap().entries.map((entry) {
          final option = entry.value;
          final controller = _optionControllers[option.localId];
          if (controller == null) return const SizedBox.shrink();

          return EditableOptionTile(
            controller: controller,
            isCorrect: option.isCorrect,
            index: entry.key,
            canRemove: q.options.length > 2,
            onToggleCorrect: () =>
                widget.onToggleCorrectOption(q.localId, option.localId),
            onRemove: () => widget.onRemoveOption(q.localId, option.localId),
            onChanged: (val) => _syncOptionTextToCubit(option.localId, val),
          );
        }),
        const SizedBox(height: 4),
        AddOptionButton(
          onTap: () => widget.onAddOption(q.localId),
        ),
      ],
    );
  }
}
