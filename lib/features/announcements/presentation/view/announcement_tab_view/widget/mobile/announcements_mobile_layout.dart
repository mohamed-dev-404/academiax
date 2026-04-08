import 'package:flutter/material.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/mobile/mobile_main_card.dart';

class AnnouncementsMobileLayout extends StatelessWidget {
  const AnnouncementsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Announcements',
          style: AppStyles.mobileTitleMediumSb.copyWith(
            color: AppColors.primaryDarkHover,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MobileMainCard(
                  cardModel: MainCardModel(
                    title: 'Makeup quiz',
                    description:
                        'Chapter 1: Database Fundamentals and theories',
                    image: AppImages.imagesAnnouncementCard,
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
