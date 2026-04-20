import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RoutesName.courses),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.iconsLogo, height: 24),
          const SizedBox(width: 8),
          Text(
            'Univerra',
            style: AppStyles.mobileTitleLargeMd.copyWith(
              fontSize: 28.sp.clamp(20, 28),
              color: AppColors.secondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
