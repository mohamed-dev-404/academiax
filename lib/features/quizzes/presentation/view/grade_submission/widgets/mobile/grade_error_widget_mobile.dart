import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class GradeErrorWidgetMobile extends StatelessWidget {
  final String errorMessage;

  const GradeErrorWidgetMobile({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: StatusColors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  errorMessage,
                  style: AppStyles.mobileBodyLargeMd.copyWith(
                    color: StatusColors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
