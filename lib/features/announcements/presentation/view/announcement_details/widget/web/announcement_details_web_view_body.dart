import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/add_comment_bar.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/announcement_card.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/shared/comments_section.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_details/widget/web/web_header_section.dart';

class AnnouncementDetailsWebViewBody extends StatelessWidget {
  const AnnouncementDetailsWebViewBody({
    super.key,
    required this.announcementId,
  });
  final String announcementId;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            const WebHeaderSection(),
            const Divider(height: 1, color: AppColors.primaryLight),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Left column: Announcement Card ──
                    const Expanded(
                      // flex: 3,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 32, right: 14),
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
                    Expanded(
                      // flex: 4,
                      child: Column(
                        children: [
                          const Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(
                                left: 18,
                                bottom: 12,
                                right: 40,
                              ),
                              child: CommentsSection(),
                            ),
                          ),
                          AddCommentBar(
                            announcementId: announcementId,
                          ),
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
