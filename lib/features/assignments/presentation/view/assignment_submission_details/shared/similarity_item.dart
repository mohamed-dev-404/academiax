import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/assignments/data/model/assignment_item_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/logic/assignment_details_handler.dart';

class SimilarityItem extends StatelessWidget {
  final int percentage;
  final String text;
  final String? url;
  final int assignmentPlagiarismThreshold;

  const SimilarityItem({
    super.key,
    required this.percentage,
    required this.text,
    this.url,
    required this.assignmentPlagiarismThreshold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          /// Circular Percentage
          CircularPercentIndicator(
            radius: 25.0,
            lineWidth: 5.0,
            percent: (percentage / 100).clamp(0.0, 1.0),

            center: Text(
              '${percentage.toInt()}%',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),

            progressColor: percentage >= assignmentPlagiarismThreshold
                ? AppColors.red
                : AppColors.primaryActive,
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),

          const SizedBox(width: 12),

          /// Text
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),

          /// Button
          GestureDetector(
            onTap: () {
              if (url != null) {
                AssignmentDetailsHandler.openMaterialItem(
                  context,
                  AssignmentItemModel(
                    displayUrl: url!,
                    originalFileName: "Reference File",
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Preview',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
