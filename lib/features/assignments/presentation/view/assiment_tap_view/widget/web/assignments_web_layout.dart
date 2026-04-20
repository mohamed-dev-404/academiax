import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/features/assignments/data/model/assiment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assiment_tap_view/widget/web/web_assiment_card.dart';

class AssignmentsWebLayout extends StatelessWidget {
  final String courseId;
  final List<AssignmentModel> assignments;
  final UserRole userRole;

  const AssignmentsWebLayout({
    super.key,
    required this.courseId,
    required this.assignments,
    required this.userRole,
  });

  @override
  
  Widget build(BuildContext context) {
    final bool isInstructor = userRole == UserRole.instructor;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assignments',
            style: AppStyles.mobileTitleSmallSb.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 24),

          if (assignments.isEmpty && !isInstructor)
            _buildEmptyState('No assignments available yet.', 300)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isInstructor
                  ? (assignments.isEmpty ? 2 : assignments.length + 1)
                  : assignments.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 400 / 440,
              ),
              itemBuilder: (context, index) {
                if (isInstructor && index == 0) {
                  return AddNewCard(
                    title: 'Create Assignment',
                    isMobile: false,
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const CreateAssignmentView(),
                      //   ),
                      // );
                    },
                  );
                }

                if (isInstructor && assignments.isEmpty && index == 1) {
                  return _buildEmptyState('Your assignment list is empty', 180);
                }

                final int dataIndex = isInstructor ? index - 1 : index;
                if (dataIndex < 0 || dataIndex >= assignments.length)
                  return const SizedBox.shrink();

                final assignment = assignments[dataIndex];
                return WebAssignmentCard(
                  assignment: assignment,
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         AssignmentDetailsView(assignmentId: assignment.id),
                    //   ),
                    // );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset(AppLottie.empty, height: height),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
