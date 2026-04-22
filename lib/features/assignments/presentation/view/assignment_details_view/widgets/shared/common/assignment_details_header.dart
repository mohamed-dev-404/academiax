import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/presentation/view/assignment_details_view/widgets/shared/common/assignment_details_state_badge.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/shared_back_button.dart';

class AssignmentDetailsHeader extends StatelessWidget {
  const AssignmentDetailsHeader({
    super.key,
    required this.assignment,
    required this.courseId,
  });

  final AssignmentModel assignment;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, isMobile ? 48 : 24, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SharedBackButton(),
                  const Gap(12),
                  AssignmentDetailsStateBadge(assignment: assignment),
                ],
              ),
              if (CurrentRole.role == UserRole.instructor)
                _buildInstructorActions(context),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            assignment.title,
            style: AppStyles.mobileTitleMediumSb.copyWith(
              color: AppColors.whiteLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            assignment.description,
            style: AppStyles.mobileBodySmallRg.copyWith(
              color: AppColors.whiteHover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorActions(BuildContext context) {
    return Container(
                          width: 38,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.redLight,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // DeleteAssignmentDialog.show(
                              //   context,
                              //   onConfirm: () {
                              //     context.read<AssignmentCubit>().deleteAssignment(
                              //       quiz.id,
                              //     );
                              //   },
                              // );
                            },
                            icon: const Icon(
                              size: 22,
                              Icons.delete_forever,
                              color: AppColors.red,
                            ),
                          ),
                        );
  }
}
