import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryDarkHover.withOpacity(0.10),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkHover.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.campaign_outlined,
                  color: AppColors.primaryDarkHover,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Makeup Quiz',
                  style: AppStyles.web30Regular.copyWith(
                    color: AppColors.primaryDarkHover,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: SvgPicture.asset(
                    AppIcons.iconsEditMaterial,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryDarkHover.withOpacity(0.7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Content
          Text(
            ''' The make-up quiz will be held tomorrow at 8:45 AM in Lab 6302.
The duration will be 30 minutes.
In addition we will proceed our classes normally this weekPlease prepare well.
Good luck to everyonennn''',
            style: AppStyles.web16Medium.copyWith(
              color: AppColors.primaryDarker,
              height: 1.75,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),

        ],
      ),
    );
  }
}