import 'package:flutter/material.dart';

class AnimatedDecisionButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const AnimatedDecisionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  State<AnimatedDecisionButton> createState() => _AnimatedDecisionButtonState();
}

class _AnimatedDecisionButtonState extends State<AnimatedDecisionButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovered ? 1.03 : 1.0),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.color),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),

        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: widget.bgColor,
                  child: Icon(widget.icon, color: widget.color),
                ),
                const SizedBox(height: 8),
                Text(widget.text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}