import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class SubmissionCard extends StatefulWidget {
  final String studentName;
  final String academicId;
  final String formattedTime;
  final String displayScore;
  final String maxScore;
  final VoidCallback? onTap;
  final bool isGraded;

  const SubmissionCard({
    super.key,
    required this.studentName,
    required this.academicId,
    required this.formattedTime,
    required this.displayScore,
    required this.maxScore,
    this.onTap, 
    required this.isGraded,
  });

  @override
  State<SubmissionCard> createState() => _SubmissionCardState();
}

class _SubmissionCardState extends State<SubmissionCard> {
  bool isHovered = false;

  //! Get initials
  String get _initials {
    List<String> names = widget.studentName.trim().split(' ');
    if (names.isEmpty) return '?';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = widget.isGraded
        ? StatusColors.green
        : StatusColors.orangeDark;
    final Color bgColor = widget.isGraded
        ? StatusColors.green.withValues(alpha: 0.04)
        : StatusColors.orangeLight.withValues(alpha: 0.5);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                //* Left side status indicator line
                Container(width: 6, color: statusColor),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //* Avatar
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: statusColor.withValues(
                            alpha: 0.15,
                          ),
                          child: Text(
                            _initials,
                            style: AppStyles.web16Semibold.copyWith(
                              color: statusColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        //* Student Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.studentName,
                                style: AppStyles.mobileBodySmallSb,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.academicId,
                                style: AppStyles.webAgBodyRegular.copyWith(
                                  color: AppColors.whiteDarkHover,
                                  //   fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //* Score and Time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: widget.displayScore,
                                style: AppStyles.mobileBodyLargeSb.copyWith(
                                  color: statusColor,
                                ),

                                children: [
                                  TextSpan(
                                    text: '/${widget.maxScore}',
                                    style: AppStyles.mobileTitleXsmallMd
                                        .copyWith(
                                          color: AppColors.whiteDarkHover,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.formattedTime,
                              style: AppStyles.mobileBodyXsmallMd.copyWith(
                                color: AppColors.whiteDarkHover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
