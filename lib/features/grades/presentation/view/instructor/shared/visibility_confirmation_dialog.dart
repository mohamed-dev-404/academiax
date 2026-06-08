import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/grades/presentation/view_model/grade_cubit/grade_cubit.dart';

class VisibilityConfirmationDialog extends StatefulWidget {
  const VisibilityConfirmationDialog({
    super.key,
    required this.columnName,
    required this.currentlyVisible,
    required this.classworkId,
  });

  final String columnName;
  final bool currentlyVisible;
  final String classworkId;

  static Future<bool> show({
    required BuildContext context,
    required String columnName,
    required bool currentlyVisible,
    required String classworkId,
  }) async {
    // Capture the cubit from the caller's context (where the provider exists)
    // BEFORE showGeneralDialog, since the dialog's overlay route is outside
    // the original widget tree and can't inherit the provider.
    final gradeCubit = context.read<GradeCubit>();

    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: AppColors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: gradeCubit,
          child: VisibilityConfirmationDialog(
            columnName: columnName,
            currentlyVisible: currentlyVisible,
            classworkId: classworkId,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: animation.value * 4,
            sigmaY: animation.value * 4,
          ),
          child: Transform.scale(
            scale: 0.95 + (0.05 * animation.value),
            child: Opacity(
              opacity: animation.value,
              child: child,
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  @override
  State<VisibilityConfirmationDialog> createState() =>
      _VisibilityConfirmationDialogState();
}

class _VisibilityConfirmationDialogState
    extends State<VisibilityConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGoingVisible = !widget.currentlyVisible;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.whiteLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.whiteHover,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              ScaleTransition(
                scale: _iconScale,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isGoingVisible
                        ? AppColors.primaryLight
                        : AppColors.redLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isGoingVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 32,
                    color: isGoingVisible ? AppColors.primary : AppColors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Change Visibility?',
                style: AppStyles.mobileTitleSmallSb.copyWith(
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Are you sure you want to '),
                    TextSpan(
                      text: isGoingVisible ? 'show ' : 'hide ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isGoingVisible
                            ? AppColors.primary
                            : AppColors.red,
                      ),
                    ),
                    TextSpan(
                      text: "'${widget.columnName}'",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: isGoingVisible
                          ? ' to students?'
                          : ' from students?',
                    ),
                  ],
                ),
                style: AppStyles.mobileBodySmallRg.copyWith(
                  color: AppColors.whiteDarkHover,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.whiteHover),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyles.mobileBodySmallMd.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<GradeCubit>().toggleClassworkVisiability(
                          classworkId: widget.classworkId,
                        );
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: AppStyles.mobileBodySmallMd.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
