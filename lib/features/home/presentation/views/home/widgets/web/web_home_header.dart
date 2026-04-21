import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/extentions/split_first_two_strings.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/cache_keys.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

//* The main header for the web home screen, containing the logo and navigation links.
class WebHomeHeader extends StatelessWidget {
  const WebHomeHeader({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final name = GetStorageHelper.read<String>(CacheKeys.name);
    final profilePicPath = GetStorageHelper.read<String>(CacheKeys.profilePic);
    return Container(
      height: height * 0.12,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      color: AppColors.primary,
      child: Row(
        children: [
          /// Logo + Name
          GestureDetector(
            onTap: () => context.goNamed(RoutesName.courses),
            child: Row(
              children: [
                SvgPicture.asset(AppIcons.iconsLogo, height: 28),
                const SizedBox(width: 8),
                Text(
                  'Univerra',
                  style: AppStyles.mobileTitleLargeMd.copyWith(
                    color: AppColors.secondaryLight,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          Row(
            children: [
              // Notification Icon
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color.fromARGB(255, 51, 148, 167),
                child: SvgPicture.asset(AppIcons.iconsNotifibationOutline),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  context.push(RoutesName.profile);
                },
                child: (profilePicPath == null || profilePicPath.isEmpty)
                    ? SvgPicture.asset(
                        AppIcons.iconsHomeProfileHeader,
                        colorFilter: const ColorFilter.mode(
                          AppColors.whiteLight,
                          BlendMode.srcIn,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(profilePicPath),
                      ),
              ),
              const SizedBox(width: 9),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning!',
                    style: AppStyles.mobileBodyXsmallRg.copyWith(
                      color: AppColors.whiteLight,
                    ),
                  ),
                  Text(
                    name == null ? 'unknown' : name.firstTwoNames,
                    style: AppStyles.webBodySmallSb.copyWith(
                      color: AppColors.whiteLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
