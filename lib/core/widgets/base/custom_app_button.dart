import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class CustomAppButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? elevation;
  final IconData? icon;
  final Widget? child;
  final TextStyle? textStyle;
  final Color? overlayColor;
  final Color? shadowColor;

  const CustomAppButton({
    super.key,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation,
    this.icon,
    this.child,
    this.textStyle,
    this.overlayColor,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.secondaryHover,
          foregroundColor: textColor ?? AppColors.primaryLight,
          elevation: elevation ?? 4,
          shadowColor: shadowColor ?? Colors.transparent,
          overlayColor: overlayColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (child != null) return child!;

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          _buildText(),
        ],
      );
    }

    return _buildText();
  }

  Widget _buildText() {
    return Text(
      label ?? '',
      style: AppStyles.mobileButtonMediumSb
          .merge(textStyle)
          .copyWith(
            color: textStyle?.color ?? textColor ?? AppColors.primaryLight,
          ),
    );
  }
}
