import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class CommentItem extends StatelessWidget {
  final String name;
  final String date;
  final String text;
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? imageUrl;

  const CommentItem({
    super.key,
    required this.name,
    required this.date,
    required this.text,
    this.isOwner = false,
    this.onEdit,
    this.onDelete,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double avatarRadius = (width * 0.077).clamp(12.0, 18.0);
        final double nameFontSize = (width * 0.050).clamp(12.0, 15.0);
        final double dateFontSize = (width * 0.040).clamp(9.0, 11.0);
        final double textFontSize = (width * 0.040).clamp(12.0, 15.0);
        final double iconSize = (width * 0.05).clamp(16.0, 20.0);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primaryLight,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        imageUrl!,
                        width: avatarRadius * 3,
                        height: avatarRadius * 3,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          color: AppColors.primaryDarkHover,
                          size: avatarRadius * 1.2,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: AppColors.primaryDarkHover,
                      size: avatarRadius * 1.2,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            AutoSizeText(
                              name,
                              minFontSize: 12,
                              style: AppStyles.web14Medium.copyWith(
                                color: AppColors.primaryDarkHover,
                                fontWeight: FontWeight.w700,
                                fontSize: nameFontSize,
                              ),
                            ),
                            AutoSizeText(
                              date,
                              style: TextStyle(
                                fontSize: dateFontSize,
                                color: Colors.grey,
                              ),
                              minFontSize: 7,
                            ),
                          ],
                        ),
                      ),
                      if (isOwner)
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                            size: iconSize,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') onEdit?.call();
                            if (value == 'delete') onDelete?.call();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: AppColors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: AppColors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: textFontSize,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
