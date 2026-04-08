import 'package:flutter/material.dart';
import 'package:sams_app/core/models/main_card_model.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/web/web_main_card.dart';

//! Materials_web_layout.dart
class AnnouncementsWebLayout extends StatelessWidget {
  const AnnouncementsWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 12, 40, 0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              'Announcements',
              style: AppStyles.webTitleMediumSb.copyWith(
                color: AppColors.primaryDarkHover,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverGrid.builder(
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 220,
              childAspectRatio: 301/240
            ),
            itemBuilder: (context, index) {
              return WebMainCard(
                model: MainCardModel(
                  title: 'Makeup quiz',
                  description: 'Chapter 1: Database Fundamentals and theories',
                  image: AppImages.imagesAnnouncementCard,
                  onTap: () {},
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
    );
  }
}
