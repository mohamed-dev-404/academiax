import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';

//* Dialog to preview an profile picture after updated
class ImagePreviewDialog extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final mobileSize = SizeConfig.isMobile(context);

    return Center(
      child: Container(
        width: mobileSize
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.5,
        height: mobileSize
            ? double.infinity
            : MediaQuery.of(context).size.height * 0.7,
        padding: mobileSize ? EdgeInsets.zero : const EdgeInsets.all(20),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Background blur
              GestureDetector(
                // Dismiss on tap
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Center(
                // Interactive viewer to zoom
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(!mobileSize ? 16 : 0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void open(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: AppColors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => ImagePreviewDialog(imageUrl: imageUrl),
    );
  }
}
