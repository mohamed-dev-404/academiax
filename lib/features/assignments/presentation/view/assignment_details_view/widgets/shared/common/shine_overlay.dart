import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

/// A specialized animation overlay that creates a "Shine" or "Glint" effect.
/// It uses a sweeping linear gradient to simulate light reflecting off a surface.
class ShineOverlay extends StatefulWidget {
  const ShineOverlay({super.key});

  @override
  State<ShineOverlay> createState() => _ShineOverlayState();
}

class _ShineOverlayState extends State<ShineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;

  @override
  void initState() {
    super.initState();
    //* Animation Sequence: A single forward sweep lasting 600ms.
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shineController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            //* Gradient Logic: The "stops" move from top-left to bottom-right
            //* based on the controller value to create the motion effect.
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _shineController.value - 0.4, // Leading transparent edge
                _shineController.value, // Peak brightness (Shine)
                _shineController.value + 0.4, // Trailing transparent edge
              ],
              colors: [
                AppColors.whiteLight.withValues(alpha: 0.0),
                AppColors.whiteLight.withValues(
                  alpha: 0.4,
                ), // Semi-transparent white glint
                AppColors.whiteLight.withValues(alpha: 0.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
