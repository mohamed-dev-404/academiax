import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_item_card.dart';

/// [AssignmentContentGrid]
class AssignmentContentGrid extends StatelessWidget {
  final AssignmentModel assignment;

  const AssignmentContentGrid({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    final attachments = assignment.assignmentItems;

    if (attachments.isEmpty) return const SizedBox.shrink();

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: [
        _buildSectionTitle('Attached Files'),
        const SizedBox(height: 12),
        _buildResponsiveGrid(context, attachments),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppStyles.web24Semibold.copyWith(
        color: AppColors.primary,
        fontSize: 20,
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context, List<dynamic> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        mainAxisExtent: 75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return AssignmentItemCard(
          fileName: item.originalFileName ?? 'Attachment ${index + 1}',
          description: '',
          icon: item.icon,
          iconColor: item.color,
          onTap: () {
            debugPrint('Opening attachment: ${item.displayUrl}');
          },
          onDelete: () {
            debugPrint('Delete requested');
          },
        );
      },
    );
  }
}
