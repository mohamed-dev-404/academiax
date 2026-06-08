import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/home/data/models/course_model.dart';

//* Displays course name and code using RichText for mixed styling
class CourseTitleRow extends StatelessWidget {
  final CourseModel course;
  final bool isMobile;
  final double w, h;

  const CourseTitleRow({
    super.key,
    required this.course,
    required this.isMobile,
    required this.w,
    required this.h,
  });
  @override
  Widget build(BuildContext context) {
    final int titleMaxLength = SizeConfig.isMobile(context) ? 30 : 24;
    return Flexible(
      flex: 2,
      child: Container(
        width: w * 0.79,
        height: h,
        alignment: isMobile ? Alignment.centerLeft : Alignment.topLeft,
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: isMobile
                ? AppStyles.mobileBodyLargeMd.copyWith(
                    color: AppColors.primaryDarker,
                  )
                : AppStyles.mobileTitleLargeMd.copyWith(
                    color: AppColors.primaryDarker,
                    fontSize: !isMobile ? w * 0.08 : null,
                  ),
            children: [
              TextSpan(
                text: course.name.length > titleMaxLength
                    ? '${course.name.substring(0, titleMaxLength)}...'
                    : course.name,
              ),
              //? Visual distinction for the academic code
              TextSpan(
                text: '(${course.academicCourseCode})',
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkActive,
                  fontSize: !isMobile ? w * 0.05 : w * 0.04,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
