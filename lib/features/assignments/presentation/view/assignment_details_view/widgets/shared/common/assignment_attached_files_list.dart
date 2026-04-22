import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_item_card.dart';

class AssignmentItemsList extends StatelessWidget {
  final AssignmentModel assignment;

  const AssignmentItemsList({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    final attachments = assignment.assignmentItems;

    if (attachments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            'Attached Files',
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: AppColors.primaryDarkHover,
              fontSize: 18,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: attachments.length,
          itemBuilder: (context, index) {
            final item = attachments[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: AssignmentItemCard(
                fileName: item.originalFileName ?? 'Attachment ${index + 1}',
                description: '',

                icon: item.icon,
                iconColor: item.color,

                onTap: () {
                  debugPrint('Opening attachment: ${item.displayUrl}');
                },
                onDelete: () {
                  debugPrint('Delete requested for attachment: ');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
