import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

/// A modal overlay used specifically for the initial file upload phase.
/// Features a blurred backdrop and a progress indicator to block user interaction.
class UploadingOverlay extends StatelessWidget {
  const UploadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    //* Positioned.fill ensures the overlay covers the entire parent Stack (usually the whole screen).
    return Positioned.fill(
      child: BackdropFilter(
        //* Frosted glass effect: Blurs the background content to emphasize the modal.
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withAlpha(77), //? Dimmed background
          child: Center(
            child: _buildMainContent(),
          ),
        ),
      ),
    );
  }

  /// Builds the central modal card containing animation and status indicators.
  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Visual feedback: Lottie animation representing upload activity.
          Lottie.asset(
            AppLottie.uploadFiles,
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Uploading materials...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          //* Indeterminate progress bar since we are waiting for a backend response.
          const LinearProgressIndicator(
            color: AppColors.secondary,
            backgroundColor: Colors.black12,
          ),
          const SizedBox(height: 20),
          const Text(
            'Please stay on this screen until completion.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.whiteDark,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
