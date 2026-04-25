import 'package:flutter/material.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/mobile_decision_buttons.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/mobile/submission_details_header.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/animated_document_card.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_submission_details/shared/similarity_item.dart';

class AssignmentSubmissionDetailsMobileLayout extends StatelessWidget {
  const AssignmentSubmissionDetailsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF158A9E),
      body: Column(
        children: [
          /// 🔹 Header
          const SubmissionDetailsHeader(),

          /// 🔹 Bottom Container
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Documents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  const AnimatedDocumentCard(
                    title: 'Assignment PDF',
                    subtitle: 'Tap to open document',
                    type: 'PDF',
                    icon: Icons.picture_as_pdf,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {
                      _showSimilarityDialog(context);
                    },
                    child: const AnimatedDocumentCard(
                      title: 'Similarity Report',
                      subtitle: 'Preview plagiarism check',
                      type: 'View',
                      icon: Icons.search,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Decision',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 16),

                  const MobileDecisionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showSimilarityDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SimilarityItem(
                percentage: 10,
                text: "Nadia's assignment is similar to Mariam's",
              ),
              SizedBox(height: 12),
              SimilarityItem(
                percentage: 80,
                text: "Nadia's assignment is similar to Mariam's",
              ),
              SizedBox(height: 12),
              SimilarityItem(
                percentage: 20,
                text: "Nadia's assignment is similar to Mariam's",
              ),
            ],
          ),
        ),
      );
    },
  );
}









