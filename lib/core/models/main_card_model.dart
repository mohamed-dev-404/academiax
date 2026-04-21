import 'package:flutter/material.dart';

class MainCardModel {
  final String title;
  final String description;
  final String image;
  final String? icon;
  final Widget? actionWidget;
  final VoidCallback onTap;
  final VoidCallback? onActionTap;

  MainCardModel({
    required this.title,
    required this.description,
    required this.image,
    this.icon,
    this.actionWidget,
    required this.onTap,
    this.onActionTap,
  });
}
