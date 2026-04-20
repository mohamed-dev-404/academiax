import 'package:flutter/material.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.model});
  final AppButtonStyleModel model;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: model.width ?? double.infinity,
      height: model.height ?? 56,
      child: ElevatedButton(
        onPressed: model.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: model.backgroundColor ?? AppColors.secondary,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            model.label,
            style: AppStyles.mobileButtonMediumSb.copyWith(
              color: model.onPressed == null
                  ? AppColors.whiteDarker
                  : (model.textColor ?? AppColors.whiteLight),
            ),
          ),
        ),
      ),
    );
  }
}
