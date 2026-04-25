import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SimilarityItem extends StatelessWidget {
  final int percentage;
  final String text;

  const SimilarityItem({
    super.key,
    required this.percentage,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = percentage / 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ///  Circular Percentage
          CircularPercentIndicator(
            radius: 28,
            lineWidth: 5,
            percent: percent,
            center: Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: Colors.orange,
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),

          const SizedBox(width: 12),

          /// Text
          Expanded(
            child: Text(
              '$text with $percentage percent',
              style: const TextStyle(fontSize: 13),
            ),
          ),

          /// Button
          Container(
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
        ],
      ),
    );
  }
}