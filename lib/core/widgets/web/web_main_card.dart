import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class WebMainCard extends StatefulWidget {
  const WebMainCard({super.key, required this.model});
  final MainCardModel model;

  @override
  State<WebMainCard> createState() => _WebMainCardState();
}

class _WebMainCardState extends State<WebMainCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : _scale, // Hover scale or Tap scale
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 301, maxHeight: 240),
          child: AspectRatio(
            aspectRatio: 301 / 240,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  color: _isHovered
                      ? AppColors.primaryLightHover.withValues(alpha: 0.9)
                      : AppColors.primaryLightHover,
                  child: InkWell(
                    onTap: widget.model.onTap,
                    onHighlightChanged: (isHighlighted) {
                      setState(() => _scale = isHighlighted ? 0.97 : 1.0);
                    },
                    splashColor: AppColors.primaryActive.withValues(alpha: 0.1),
                    highlightColor: Colors.transparent,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;

                        return Stack(
                          children: [
                            // Action Button Logic (Same as Mobile)
                            Positioned(
                              top: h * 0.05,
                              right: w * 0.05,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: IconButton(
                                  key: ValueKey(widget.model.icon),
                                  onPressed: widget.model.onActionTap,
                                  splashRadius: 20,
                                  icon:
                                      widget.model.actionWidget ??
                                      SvgPicture.asset(
                                        widget.model.icon ?? AppIcons.iconsMore,
                                        width: w * 0.08,
                                        height: w * 0.08,
                                      ),
                                ),
                              ),
                            ),

                            // Image Section
                            Positioned(
                              top: h * 0.12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: SvgPicture.asset(
                                  widget.model.image,
                                  width: w * 0.55,
                                  height: h * 0.5,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Text Content
                            Positioned(
                              bottom: h * 0.08,
                              left: w * 0.08,
                              right: w * 0.08,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.model.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.webBodySmallSb.copyWith(
                                      color: AppColors.primaryDarkHover,
                                      fontSize: (w * 0.06).clamp(16, 20),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.model.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.mobileBodySmallRg.copyWith(
                                      color: AppColors.primaryDark.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: (w * 0.045).clamp(12, 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
