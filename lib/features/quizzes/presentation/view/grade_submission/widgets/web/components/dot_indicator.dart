import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

/// Animated dot indicator for question navigation in the web layout.
///
/// Shows up to 10 dots. The active dot expands horizontally
/// to indicate the current position.
class DotIndicator extends StatelessWidget {
  final int total;
  final int current;

  const DotIndicator({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    final int show = total.clamp(0, 10);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(show, (i) {
        final bool active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : AppColors.secondaryLightActive,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
