import 'package:flutter/material.dart';

class AppButtonStyleModel {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const AppButtonStyleModel({
    required this.label,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.height,
    this.width,
  });
}
