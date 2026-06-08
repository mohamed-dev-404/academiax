import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_animated_loading_indicator.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/classwork_item_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/create_quiz/widgets/shared/classwork_tile.dart';

/// The inner content of the classwork picker.
///
/// Renders one of three visual states:
///   • [ClassworkListStatus.loading]  → centered loading spinner
///   • [ClassworkListStatus.error]    → error icon + message
///   • [ClassworkListStatus.loaded]   → list of [ClassworkTile] items
///                                      (or an empty-state if list is empty)
///
/// Note: The "Add" button is intentionally NOT part of this widget.
/// It is pinned at the bottom of the picker dialog so it stays visible
/// even when the list scrolls.
class ClassworkListContent extends StatelessWidget {
  final ClassworkListStatus status;
  final List<ClassworkItemModel> items;
  final String? selectedId;
  final String? errorMessage;
  final ValueChanged<ClassworkItemModel> onSelected;

  const ClassworkListContent({
    super.key,
    required this.status,
    this.items = const [],
    this.selectedId,
    this.errorMessage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ClassworkListStatus.loading => _buildLoading(),
      ClassworkListStatus.error => _buildError(),
      ClassworkListStatus.loaded =>
        items.isEmpty ? _buildEmpty() : _buildList(),
    };
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60.0),
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: AppAnimatedLoadingIndicator(),
        ),
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            errorMessage ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: AppStyles.mobileBodySmallMd.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }

  // ── Empty ─────────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inbox_outlined,
            color: AppColors.whiteDarkActive,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No assigned classworks found.',
            textAlign: TextAlign.center,
            style: AppStyles.mobileBodySmallMd.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  // ── Classwork List ────────────────────────────────────────────────────────
  Widget _buildList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return ClassworkTile(
          item: item,
          isSelected: item.id == selectedId,
          onTap: () => onSelected(item),
        );
      }).toList(),
    );
  }
}

/// The three possible visual states for [ClassworkListContent].
enum ClassworkListStatus { loading, error, loaded }
