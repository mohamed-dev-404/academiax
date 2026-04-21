import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

//* The main layout for the mobile home screen, organizing course summaries and the role-based 'NewCourseCard' in a scrollable view.
class MobileHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? imagePath;
  const MobileHomeAppBar({
    super.key,
    required this.userName,
    this.imagePath,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final headerWidth = constraints.maxWidth;

        // Header height
        final headerHeight = headerWidth * 0.22;

        // Sizes relative to header
        final profileIconSize = headerHeight * 0.45;
        final notificationIconSize = headerHeight * 0.5;

        // Spacing
        final spaceBetweenAvatarAndText = headerWidth * 0.03;

        return AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //? Profile Icon
                  SizedBox(
                    width: profileIconSize,
                    height: profileIconSize,
                    child: GestureDetector(
                      onTap: () {
                        context.push(RoutesName.profile);
                      },
                      child: (imagePath == null || imagePath!.isEmpty)
                          ? SvgPicture.asset(
                              AppIcons.iconsHomeProfileHeader,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(imagePath!),
                            ),
                    ),
                  ),
                  SizedBox(width: spaceBetweenAvatarAndText),
                  //? User Name
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning!',
                        style: AppStyles.mobileBodySmallRg.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        height: headerWidth * .07,
                        width: headerWidth * .6,
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            userName,
                            style: AppStyles.mobileBodyLargeSb.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //? Notification Icon
              IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  AppIcons.iconsHomeNotificationHeader,
                  width: notificationIconSize,
                  height: notificationIconSize,
                ),
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => const MobileNotificationView(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
