import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class MobileMainCard extends StatefulWidget {
  const MobileMainCard({super.key, required this.cardModel});
  final MainCardModel cardModel;

  @override
  State<MobileMainCard> createState() => _MobileMainCardState();
}

class _MobileMainCardState extends State<MobileMainCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = cardWidth * 0.4;

        return AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: AppColors.primaryLightHover,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.cardModel.onTap,
                  onHighlightChanged: (isHighlighted) {
                    setState(() => _scale = isHighlighted ? 0.96 : 1.0);
                  },
                  splashColor: AppColors.primaryActive.withValues(alpha: 0.1),
                  highlightColor: AppColors.primaryActive.withValues(
                    alpha: 0.05,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(cardWidth * 0.03),
                    child: Stack(
                      children: [
                        _buildMainRow(cardWidth, cardHeight),

                        _buildActoinButton(cardHeight),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainRow(double cardWidth, double cardHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImage(cardWidth, cardHeight),
        Expanded(child: _buildTextSection(cardWidth, cardHeight)),
      ],
    );
  }

  Widget _buildImage(double cardWidth, double cardHeight) {
    return Container(
      width: cardWidth * 0.33,
      height: cardHeight,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: SvgPicture.asset(
          widget.cardModel.image,
          fit: BoxFit.contain,
          width: (cardWidth * 0.2).clamp(100.0, 300.0),
          height: (cardHeight * 0.9).clamp(100.0, 300.0),
        ),
      ),
    );
  }

  Widget _buildTextSection(double cardWidth, double cardHeight) {
    return Padding(
      padding: EdgeInsets.only(right: cardWidth * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildText(
            text: widget.cardModel.title,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            maxLines: 2,
            fontSizeFactor: 0.16,
            fontStyle: AppStyles.mobileBodyLargeSb,
            color: AppColors.primaryDarkHover,
          ),
          SizedBox(height: cardHeight * 0.05),
          _buildText(
            text: widget.cardModel.description,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            maxLines: 2,
            fontSizeFactor: 0.11,
            fontStyle: AppStyles.mobileBodySmallRg,
          ),
        ],
      ),
    );
  }

  Widget _buildText({
    required String text,
    required double cardWidth,
    required double cardHeight,
    required int maxLines,
    required double fontSizeFactor,
    required TextStyle fontStyle,
    Color? color,
  }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: fontStyle.copyWith(
        color: color ?? AppColors.primaryDark,
        fontSize: (cardHeight * fontSizeFactor).clamp(14.0, 20.0),
      ),
    );
  }

  Widget _buildActoinButton(double cardHeight) {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: IconButton(
          key: ValueKey(widget.cardModel.icon),
          onPressed: widget.cardModel.onActionTap,
          splashRadius: 24,
          icon: Transform.scale(
            scale: (cardHeight / 140).clamp(0.8, 1.2),
            child:
                widget.cardModel.actionWidget ??
                SvgPicture.asset(
                  widget.cardModel.icon ?? AppIcons.iconsMore,
                  width: 24,
                  height: 24,
                ),
          ),
        ),
      ),
    );
  }
}
