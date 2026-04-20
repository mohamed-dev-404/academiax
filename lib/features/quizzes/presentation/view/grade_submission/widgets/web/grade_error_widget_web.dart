import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class GradeErrorWidgetWeb extends StatelessWidget {
  final String errorMessage;

  const GradeErrorWidgetWeb({super.key, required this.errorMessage});

  static const _bgColor = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: StatusColors.red,
                size: 32,
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  errorMessage,
                  style: AppStyles.web24Medium.copyWith(
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
