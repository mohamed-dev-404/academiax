import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/widget/shared/shine_overlay.dart';

/// Defines the supported categories of course content.
enum CourseMaterialType { pdf, video }

/// [MaterialItemCard]
/// A sophisticated interactive card designed to represent individual material assets (PDFs or Videos).
/// It features complex micro-interactions including hover states, pulse animations, and shine overlays
/// to provide high-quality tactile feedback.
class MaterialItemCard extends StatefulWidget {
  final String fileName;
  final String description;
  final CourseMaterialType materialType;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MaterialItemCard({
    super.key,
    required this.fileName,
    required this.description,
    required this.materialType,
    this.icon,
    this.iconColor,
    this.onTap,
    this.onDelete,
  });

  @override
  State<MaterialItemCard> createState() => _MaterialItemCardState();
}

class _MaterialItemCardState extends State<MaterialItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //* State Management for Micro-interactions.
  bool _isShining = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    //* Pulse Effect: Short duration (100ms) to ensure the haptic-like feedback feels snappy and responsive.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    //* Resource cleanup: Prevent memory leaks from active animation controllers.
    _controller.dispose();
    super.dispose();
  }

  /// Manages the multi-phase execution of a card tap.
  void _handleTap() {
    //* Phase 1: Visual Feedback - Trigger the pulse (forward/reverse) and shine layer.
    _controller.forward().then((_) => _controller.reverse());
    setState(() => _isShining = true);

    //* Phase 2: Action Delegation - Execute [onTap] after a brief delay
    //* to ensure the user perceives the visual confirmation.
    Future.delayed(const Duration(milliseconds: 200), () {
      widget.onTap?.call();
      if (mounted) setState(() => _isShining = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    //_ Logical extractions: Determine asset paths and color themes before rendering.
    final String iconPath = _getIconPath();
    final Color finalIconColor = _getIconColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        //? Scale Logic: Shrinks the card slightly (3%) during interaction to simulate depth.
        builder: (context, child) => _buildScaleTransition(child!),
        child: SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildMainCard(finalIconColor, iconPath),
              _buildShineEffect(),
            ],
          ),
        ),
      ),
    );
  }

  //_ Helper: Animated Main Card Container
  Widget _buildMainCard(Color iconColor, String iconPath) {
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
            _buildIcon(iconColor, iconPath),
            const SizedBox(width: 12),
            _buildFileDetails(),
            (CurrentRole.role == UserRole.instructor)
                ? _buildDeleteButton()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  //_ UI Part: Dynamic File Info (Adapts lines based on hover state)
  Widget _buildFileDetails() {
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
            //? UX Choice: Allow more lines on hover to reveal full title without layout breaking.
            maxLines: _isHovered ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.mobileBodyLargeMd.copyWith(
              color: AppColors.primaryDarkHover,
              height: 1.2,
            ),
          ),
          if (widget.description.isNotEmpty && !_isHovered) ...[
            const SizedBox(height: 2),
            Text(
              widget.description,
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

  //_ UI Part: Administrative Control (Delete)
  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.red, size: 20),
      onPressed: widget.onDelete,
    );
  }

  //_ Animation Helper: Handles the 3D pulse scaling effect.
  Widget _buildScaleTransition(Widget child) {
    double pulseScale = 1.0 - (_controller.value * 0.03);
    return Transform.scale(
      scale: _controller.isAnimating ? pulseScale : 1.0,
      child: child,
    );
  }

  //_ Styling Helper: Returns dynamic decoration based on Hover/Idle states.
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

  //_ Rendering Layer: Shine Overlay (Triggered on tap for visual "pop")
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

  //* Logic Mapping: Content Type -> Visual Asset
  String _getIconPath() => widget.materialType == CourseMaterialType.video
      ? AppIcons.iconsVideoMaterial
      : AppIcons.iconsPdfMaterials;

  //* Logic Mapping: Content Type -> Theme Color
  Color _getIconColor() =>
      widget.iconColor ??
      (widget.materialType == CourseMaterialType.video
          ? AppColors.primary
          : AppColors.red);
  //* Logic Mapping: Content Type -> Icon
  Widget _buildIcon(Color color, String path) {
    return Container(
      margin: EdgeInsets.only(top: _isHovered ? 4 : 0),
      child: widget.icon != null
          ? Icon(widget.icon, size: 36, color: color)
          : SvgPicture.asset(
              path,
              width: 40,
              height: 40,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
    );
  }
}
