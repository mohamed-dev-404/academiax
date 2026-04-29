import 'package:flutter/material.dart';

/// A custom action button used to approve all submissions at once.
/// It dynamically changes its UI state based on [isLoading] and [isSuccess] flags.
class ApproveAllButton extends StatelessWidget {
  /// Callback triggered when the button is pressed.
  final VoidCallback? onTap;
  /// Whether the approval process is currently in progress.
  /// Shows a CircularProgressIndicator and disables interactions when true.
  final bool isLoading;
  /// Whether the approval process completed successfully.
  /// Changes the button color to green and the icon to 'done_all' when true.
  final bool isSuccess;

  const ApproveAllButton({super.key, this.onTap, required this.isLoading, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton( // Changed to normal ElevatedButton to control layout better
    onPressed: (isLoading || isSuccess) ? null : onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF8A00),
      disabledBackgroundColor: isSuccess ? const Color(0xff4CAF50) : const Color(0xFFFF8A00).withOpacity(0.6),
      disabledForegroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
    child: AnimatedSwitcher( // Smooth transition between Loading, Success, and Text
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isSuccess ? Icons.done_all : Icons.check, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  isSuccess ? 'Approved' : 'Approve All',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
    ),
  );
  }
}
