import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

//* Displays the role-based instructor 'AddNewMaterialCard'
class AddNewCard extends StatelessWidget {
  const AddNewCard({
    super.key,
    this.isMobile = false,
    required this.title,
    required this.onTap,
    this.hight,
  });

  final Function() onTap;
  final String title;
  final bool isMobile;
  final double? hight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;
        final double cardHeight = isMobile ? cardWidth * 0.37 : cardWidth * 0.8;
        //? Aspect ratios defined to match design specs for different platforms
        return GestureDetector(
          onTap: () => onTap(),
          child: Opacity(
            opacity: .65,
            child: DottedBorder(
              color: AppColors.secondary,
              strokeWidth: 1.5,
              dashPattern: const [6, 2],
              borderType: BorderType.RRect,
              radius: Radius.circular(isMobile ? 15 : 20),
              child: Container(
                width: double.infinity,
                height: hight ?? cardHeight,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: AppColors.primaryLightHover,
                  borderRadius: BorderRadius.circular(isMobile ? 15 : 20),
                ),
                child: Stack(
                  children: [
                    _buildAddIcon(cardHeight, isMobile),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //! Build add icon in the center
  Widget _buildAddIcon(double cardHeight, bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.iconsAdd,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryDark,
              BlendMode.srcIn,
            ),
            height: isMobile ? cardHeight * 0.35 : 30,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppStyles.mobileBodyLargeRg.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
