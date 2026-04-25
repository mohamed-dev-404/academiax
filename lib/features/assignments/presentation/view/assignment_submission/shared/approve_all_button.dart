import 'package:flutter/material.dart';

class ApproveAllButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ApproveAllButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.check, color: Colors.white, size: 18),
      label: const Text(
        "Approve All",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8A00), // 🔥 Orange color
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 👈 Rounded زي الصورة
        ),
      ),
    );
  }
}
