import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/add_classwork_dialog.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_list_content.dart';
import 'package:sams_app/features/quizzes/presentation/view_model/create_quiz_cubit/create_quiz_cubit.dart';

/// Opens the classwork picker as a **dialog** (web ≥ 500px) or
/// **bottom-sheet** (mobile < 500px).
///
/// Flow:
///   1. [show] triggers [CreateQuizCubit.getAvailableClassworks].
///   2. A [BlocBuilder] maps cubit states → [ClassworkListContent] status.
///   3. User taps a tile → [CreateQuizCubit.onClassworkSelected] → dismiss.
///   4. User taps "+" → opens [AddClassworkDialog] → on success the cubit
///      auto-refreshes the list and the picker updates automatically.
class ClassworkPickerDialog {
  ClassworkPickerDialog._();

  /// Entry point — decides between dialog (web) and bottom-sheet (mobile).
  static void show(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    // Trigger the fetch before opening the picker
    cubit.getAvailableClassworks();

    final isWide = MediaQuery.of(context).size.width >= 500;

    if (isWide) {
      _showAsDialog(context, cubit);
    } else {
      _showAsBottomSheet(context, cubit);
    }
  }

  // ── Web: centered dialog ──────────────────────────────────────────────────
  static void _showAsDialog(BuildContext context, CreateQuizCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColors.whiteLight,
          child: const SizedBox(
            width: 500,
            child: _PickerBody(showHandle: false),
          ),
        ),
      ),
    );
  }

  // ── Mobile: bottom sheet ──────────────────────────────────────────────────
  static void _showAsBottomSheet(BuildContext context, CreateQuizCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _PickerBody(showHandle: true),
      ),
    );
  }
}

/// The shared content rendered inside both the dialog and bottom-sheet.
///
/// Layout (top → bottom):
///   • Header (drag handle on mobile, title, divider)
///   • Scrollable content area — [ClassworkListContent] (constrained height)
///   • Pinned "+" add button — always visible at the bottom
class _PickerBody extends StatelessWidget {
  final bool showHandle;

  const _PickerBody({required this.showHandle});

  @override
  Widget build(BuildContext context) {
    // Cap the picker at 55% of screen height so it never overflows
    final maxContentHeight = MediaQuery.of(context).size.height * 0.55;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxContentHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Fixed header ──
              _buildHeader(),

              // ── Scrollable content area ──
              Flexible(child: _buildScrollableContent(context)),

              // ── Pinned add button ──
              _buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHandle) ...[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.whiteActive,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Center(
          child: Text(
            'Select Classwork',
            style: AppStyles.mobileTitleSmallSb.copyWith(
              color: AppColors.primaryDarkHover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: AppColors.whiteHover, thickness: 1),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── Scrollable content (loading / error / empty / tile list) ──────────────
  Widget _buildScrollableContent(BuildContext context) {
    final cubit = context.read<CreateQuizCubit>();

    return BlocBuilder<CreateQuizCubit, CreateQuizState>(
      buildWhen: (_, curr) =>
          curr is AvailableClassworksLoading ||
          curr is AvailableClassworksLoaded ||
          curr is AvailableClassworksFailure,
      builder: (context, state) {
        final ClassworkListStatus status;
        final String? errorMessage;
        final items = state is AvailableClassworksLoaded
            ? state.classworks
            : const [];

        if (state is AvailableClassworksFailure) {
          status = ClassworkListStatus.error;
          errorMessage = state.message;
        } else if (state is AvailableClassworksLoaded) {
          status = ClassworkListStatus.loaded;
          errorMessage = null;
        } else {
          status = ClassworkListStatus.loading;
          errorMessage = null;
        }

        return SingleChildScrollView(
          child: ClassworkListContent(
            status: status,
            items: List.from(items),
            selectedId: cubit.selectedClasswork?.id,
            errorMessage: errorMessage,
            onSelected: (item) {
              cubit.onClassworkSelected(item);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  // ── Pinned Add Button (always visible at bottom) ──────────────────────────
  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Center(
        child: InkWell(
          onTap: () => AddClassworkDialog.show(context),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
