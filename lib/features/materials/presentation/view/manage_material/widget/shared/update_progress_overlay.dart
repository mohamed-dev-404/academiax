import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sams_app/core/utils/assets/app_lottie.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_state.dart';

/// A full-screen blocking overlay used to communicate progress during background operations.
/// It dynamically changes its visual feedback (Lottie animation) based on the [operationType] provided.
class UpdateProgressOverlay extends StatelessWidget {
  final String message;
  final MaterialOperationType operationType;

  const UpdateProgressOverlay({
    super.key,
    required this.message,
    required this.operationType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //* Backdrop: High-opacity dark overlay to focus user attention and block interactions.
      color: AppColors.primaryDarker.withAlpha(230),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //* Dynamic Animation Selection
            Lottie.asset(
              _getLottieAsset(),
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            //* Primary Feedback Message
            Text(
              message,
              style: AppStyles.mobileBodyLargeSb.copyWith(
                color: AppColors.whiteLight,
              ),
            ),
            const SizedBox(height: 10),
            //* Critical Warning: Advising the user against interrupting the process.
            _buildWarningText(),
          ],
        ),
      ),
    );
  }

  /// Logic: Match the Lottie animation to the current CRUD operation using Enum.
  String _getLottieAsset() {
    switch (operationType) {
      case MaterialOperationType.deleting:
        return AppLottie.delete;
      case MaterialOperationType.uploading:
        return AppLottie.uploadFiles;
      case MaterialOperationType.saving:
      case MaterialOperationType.general:
        return AppLottie.edit;
    }
  }

  /// Builds the cautionary message to prevent user from exiting.
  Widget _buildWarningText() {
    return const Text(
      'Please stay on this screen until completion.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.whiteDark,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}
