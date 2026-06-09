import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class MeetingHandler {
  static Future<void> launchExternalUrl(
    BuildContext context,
    String urlString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final Uri uri = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(uri)) {
        if (kIsWeb) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(uri, mode: mode);
        }
      } else {
        if (context.mounted) {
          AppToast.error(context, 'Could not launch $urlString');
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
