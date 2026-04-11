import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/add_comment_bar.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/announcement_card.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comments_section.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/web/web_header_section.dart';

class AnnouncementDetailsWebViewBody extends StatelessWidget {
  const AnnouncementDetailsWebViewBody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            const WebHeaderSection(),
            const Divider(height: 1, color: AppColors.primaryLight),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Left column: Announcement Card ──
                     const Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 32, right: 16),
                        child: AnnouncementCard(),
                      ),
                    ),

                    // ── Vertical Divider ──
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.primaryDarkHover.withOpacity(0.08),
                    ),

                    // ── Right column: Comments + input ──
                    const Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(
                                left: 24,
                                bottom: 12,
                              ),
                              child: CommentsSection(),
                            ),
                          ),
                          AddCommentBar(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

