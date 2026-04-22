import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/shine_overlay.dart';


class AssignmentItemCard extends StatefulWidget {
  final String fileName; 
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AssignmentItemCard({
    super.key,
    required this.fileName,
     this.description,
    this.icon,
    this.iconColor,
    this.onTap,
    this.onDelete,
  });

  @override
  State<AssignmentItemCard> createState() => _AssignmentItemCardState();
}

class _AssignmentItemCardState extends State<AssignmentItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _isShining = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    setState(() => _isShining = true);

    Future.delayed(const Duration(milliseconds: 200), () {
      widget.onTap?.call();
      if (mounted) setState(() => _isShining = false);
    });
  }

  @override
  Widget build(BuildContext context) {

    final Color finalIconColor = widget.iconColor ?? AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => _buildScaleTransition(child!),
        child: SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildMainCard(finalIconColor),
              _buildShineEffect(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(Color iconColor) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 70),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: _buildCardDecoration(),
        child: Row(
          crossAxisAlignment: _isHovered
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            _buildIcon(iconColor),
            const SizedBox(width: 12),
            _buildAssignmentDetails(),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentDetails() {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            widget.fileName,
            minFontSize: 16,
            maxFontSize: 24,
            maxLines: _isHovered ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.mobileBodyLargeMd.copyWith(
              color: AppColors.primaryDarkHover,
              height: 1.2,
            ),
          ),
          if (widget.description!.isNotEmpty && !_isHovered) ...[
            const SizedBox(height: 2),
            Text(
              widget.description ?? '',
              maxLines: 1,
              style: AppStyles.mobileBodySmallRg.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.red, size: 20),
      onPressed: widget.onDelete,
    );
  }

  Widget _buildScaleTransition(Widget child) {
    double pulseScale = 1.0 - (_controller.value * 0.03);
    return Transform.scale(
      scale: _controller.isAnimating ? pulseScale : 1.0,
      child: child,
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: _isHovered ? AppColors.white : AppColors.greenLight,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryDarkHover.withAlpha(_isHovered ? 30 : 12),
          blurRadius: _isHovered ? 25 : 15,
          offset: Offset(0, _isHovered ? 8 : 4),
        ),
      ],
      border: Border.all(
        color: _isHovered
            ? AppColors.primary.withValues(alpha: 0.5)
            : Colors.transparent,
        width: 1.5,
      ),
    );
  }

  Widget _buildShineEffect() {
    if (!_isShining) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: const ShineOverlay(),
        ),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    return Container(
      margin: EdgeInsets.only(top: _isHovered ? 4 : 0),
      child: widget.icon != null
          ? Icon(widget.icon, size: 36, color: color)
          : SvgPicture.asset(
              AppIcons
                  .iconsPdfMaterials, 
              width: 40,
              height: 40,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
    );
  }
}
