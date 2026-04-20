import 'package:flutter/material.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/shared/add_new_card.dart';
import 'package:sams_app/features/assignments/data/model/assiment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assiment_tap_view/widget/mobile/mobile_assiment_card.dart';

class AssignmentsMobileLayout extends StatelessWidget {
  final String courseId;
  final List<AssignmentModel> assignments;
  final UserRole userRole;

  const AssignmentsMobileLayout({
    super.key,
    required this.courseId,
    required this.assignments,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInstructor = userRole == UserRole.instructor;
    final int headerCount = isInstructor ? 2 : 1;

    return ListView.builder(
      itemCount: headerCount + (assignments.isEmpty ? 1 : assignments.length),
      itemBuilder: (context, index) {
        // 1. Title
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Assignments',
              style: AppStyles.mobileTitleSmallSb.copyWith(fontSize: 24),
            ),
          );
        }

        // 2. Instructor Add Button
        if (isInstructor && index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AddNewCard(
              title: 'Create Assignment',
              isMobile: true,
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const CreateAssignmentView(),
                //   ),
                // );
              },
            ),
          );
        }

        // 3. Empty State
        if (assignments.isEmpty) {
         // return Center(child: Lottie.asset(AppLottie.empty));
          return const Center(child: Text('No assignments available yet.'));
        }

        // 4. Assignment Cards
        final int assignmentIndex = index - headerCount;
        final assignment = assignments[assignmentIndex];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: MobileAssignmentCard(
            assignment: assignment,
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         AssignmentDetailsView(assignmentId: assignment.id),
              //   ),
              // );
            },
          ),
        );
      },
    );
  }
}
