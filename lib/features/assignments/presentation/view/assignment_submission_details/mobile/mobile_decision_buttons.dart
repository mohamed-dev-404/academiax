import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/animated_decision_button.dart';

class MobileDecisionButtons extends StatelessWidget {
  const MobileDecisionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedDecisionButton(
            text: "Accept",
            icon: Icons.check,
            color: Colors.teal,
            bgColor: const Color(0xFFE8F5F2),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnimatedDecisionButton(
            text: "Reject",
            icon: Icons.close,
            color: Colors.red,
            bgColor: const Color(0xFFFDECEC),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
