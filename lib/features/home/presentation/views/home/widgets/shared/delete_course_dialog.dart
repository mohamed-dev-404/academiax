import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/custom_app_button.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_state.dart';

//* Confirmation dialog to prevent accidental course deletion
class DeleteCourseDialog extends StatelessWidget {
  const DeleteCourseDialog({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  final String courseId;
  final String courseName;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = SizeConfig.isMobile(context);
    final double screenWidth = SizeConfig.screenWidth(context);

    return AlertDialog(
      backgroundColor: AppColors.whiteLight,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : screenWidth * 0.25,
        vertical: 20,
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      actionsPadding: const EdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Delete $courseName?',
        // textAlign: TextAlign.center,
      ),
      titleTextStyle: AppStyles.mobileTitleMediumSb.copyWith(
        color: AppColors.primaryDarkHover,
      ),
      content: Text(
        'Are you sure you want to delete this course? All data and progress will be permanently removed.',
        style: AppStyles.mobileBodyMediumRg.copyWith(
          color: AppColors.primaryDark,
        ),
      ),
      actions: [
        BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            /// Close dialog and notify user on successful deletion
            if (state is RemoveCourseSuccess || state is RemoveCourseFailure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                /// check if the dialog can be popped
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  if (state is RemoveCourseSuccess) {
                    //* Show success snackbar
                    AppSnackBar.success(context, state.message);
                  } else if (state is RemoveCourseFailure) {
                    //! Show error snackbar
                    AppSnackBar.error(context, state.errMessage);
                  }
                }
              });
            }
          },
          builder: (context, state) {
            //? Show loading indicator
            if (state is RemoveCourseLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryDark,
                  ),
                ),
              );
            }

            return Row(
              children: [
                //* Cancel button
                Expanded(
                  child: CustomAppButton(
                    label: 'Cancel',
                    height: 40,
                    textColor: AppColors.primaryDark,
                    backgroundColor: AppColors.secondaryLight,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  //! Delete course button
                  child: CustomAppButton(
                    label: 'Delete',
                    height: 40,
                    textColor: AppColors.primaryDark,
                    backgroundColor: AppColors.secondaryLight,
                    onPressed: () {
                      context.read<HomeCubit>().removeCourse(
                        courseId: courseId,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
