import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/shared/general_arrow_back.dart';

//* A standardized AppBar implementation for mobile screens providing custom navigation and flexible styling.
class MobileCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MobileCustomAppBar({
    super.key,
    required this.title,
     this.titleStyle,
     this.arrowBackColor, this.onTap,
  });
  final String title;
  final TextStyle? titleStyle;
  final Color? arrowBackColor;
  final VoidCallback? onTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    //* AppBar implementation
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(title, style: titleStyle ?? AppStyles.mobileTitleLargeMd.copyWith(
          color: AppColors.primaryDarkHover,
        ),),
      leading: IconButton(
        onPressed: onTap ?? () => context.pop(),
        icon: GeneralArrowBack(color: arrowBackColor ?? AppColors.primaryDarkHover),
      ),
    );
  }
}
