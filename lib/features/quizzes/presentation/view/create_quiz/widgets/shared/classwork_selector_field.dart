import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/text_field_type.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/widgets/base/app_text_field.dart';
import 'package:sams_app/core/widgets/shared/titled_input_field.dart';
import 'package:sams_app/features/home/data/models/classwork_model.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';

/// A tap-able field that looks like a text input but opens a bottom-sheet
/// selector for choosing a [ClassworItemkModel].
///
/// In Edit mode, pass [isReadOnly] = `true` to lock the selection.
/// The field still displays the currently-assigned value but the bottom-sheet
/// will not open and the chevron is replaced with a lock icon.
class ClassworkSelectorField extends StatelessWidget {
  final ClassworkItemModel? selectedClasswork;
  final List<ClassworkItemModel> classworkItems;

  /// Called when the user picks a different classwork item.
  /// Ignored when [isReadOnly] is `true`.
  final ValueChanged<ClassworkItemModel> onSelected;

  const ClassworkSelectorField({
    super.key,
    required this.selectedClasswork,
    required this.classworkItems,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      // Disable tap in read-only mode
      onTap: () => _showClassworkSheet(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          // Show lock icon when read-only, chevron otherwise
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primaryDark,
          ),
        ),
        child: selectedClasswork != null
            ? Text(
                '${selectedClasswork!.name}  •  ${selectedClasswork!.points} pts',
                style: AppStyles.mobileBodySmallMd.copyWith(
                  color: AppColors.primaryDarkHover,
                ),
              )
            : Text(
                'Select assigned classwork',
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkHover,
                ),
              ),
      ),
    );
  }

  // ──────────────── Bottom Sheet / Dialog ────────────────

  void _showClassworkSheet(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 800) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: AppColors.whiteLight,
            child: SizedBox(
              width: 500,
              child: _ClassworkSelectionSheet(
                items: classworkItems,
                selectedId: selectedClasswork?.id,
                onSelected: (item) {
                  onSelected(item);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.whiteLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (sheetContext) {
          return _ClassworkSelectionSheet(
            items: classworkItems,
            selectedId: selectedClasswork?.id,
            onSelected: (item) {
              onSelected(item);
              Navigator.of(sheetContext).pop();
            },
          );
        },
      );
    }
  }
}

// ══════════════════════════════════════════════════════════════
//  Private Bottom-Sheet Content
// ══════════════════════════════════════════════════════════════

class _ClassworkSelectionSheet extends StatelessWidget {
  final List<ClassworkItemModel> items;
  final String? selectedId;
  final ValueChanged<ClassworkItemModel> onSelected;

  const _ClassworkSelectionSheet({
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });

  Future<ClassworkModel?> showAddClassworkDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController pointsController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog<ClassworkModel>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitledInputField(
                    label: 'Quiz Title',
                    child: AppTextField(
                      hintText: 'e.g. Quiz 3',
                      controller: nameController,
                      textFieldType: TextFieldType.normal,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TitledInputField(
                    label: 'Total Marks',
                    child: AppTextField(
                      hintText: 'e.g. 5',
                      controller: pointsController,
                      textFieldType: TextFieldType.numerical,
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    model: AppButtonStyleModel(
                      label: 'Done',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final newClasswork = ClassworkModel(
                            name: nameController.text.trim(),
                            points: double.parse(pointsController.text.trim()),
                          );
                          //TODO hit the post now class work
                          Navigator.of(context).pop(newClasswork);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle bar ──
            if (MediaQuery.of(context).size.width < 800) ...[
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.whiteActive,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Title ──
            Text(
              'Select Classwork',
              style: AppStyles.mobileTitleSmallSb.copyWith(
                color: AppColors.primaryDarkHover,
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: AppColors.whiteHover, thickness: 1),
            const SizedBox(height: 4),

            // ── Items ──
            ...items.map((item) {
              final bool isSelected = item.id == selectedId;
              return _ClassworkTile(
                item: item,
                isSelected: isSelected,
                onTap: () => onSelected(item),
              );
            }),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();

                    final ClassworkModel? newClasswork =
                        await showAddClassworkDialog(context);

                    if (newClasswork != null) {
                      // Here you can do the following:
                      // - Update the UI to add the new item to the list (using setState or Bloc/Provider).
                      // - Call the API (POST request) that you attached in the Postman screenshot to upload the new classwork to the server.

                      print(
                        'Created Classwork: ${newClasswork.name} with ${newClasswork.points} points',
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.teal,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Single Tile
// ══════════════════════════════════════════════════════════════

class _ClassworkTile extends StatelessWidget {
  final ClassworkItemModel item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClassworkTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryLight : AppColors.whiteLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.whiteHover,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.whiteDarkHover,
                  width: 2,
                ),
                color: isSelected ? AppColors.secondary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),

            // Name & points
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppStyles.mobileBodySmallMd.copyWith(
                      color: isSelected
                          ? AppColors.primaryDarkHover
                          : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.points} points',
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteDarkActive,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
