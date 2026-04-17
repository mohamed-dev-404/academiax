import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/app_constants.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A robust preview screen that renders documents using an embedded Webview.
/// Supports both in-app viewing via Google Docs Viewer and external handling.
class FilePreviewScreen extends StatefulWidget {
  final String url;
  final String fileName;

  const FilePreviewScreen({
    super.key,
    required this.url,
    required this.fileName,
  });

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    //* Integration: Wrapping the file URL with Google GView to handle office/pdf docs in-app.
    final String googleDocUrl = '${AppConstants.googleDocUrl}${widget.url}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            //_ Update UI state to hide the loader once the document is rendered.
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(googleDocUrl));
  }

  /// Utility to handle external interactions like downloading or opening in specialized apps.
  Future<void> _launchExternal(LaunchMode mode) async {
    final Uri uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the file')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: AppStyles.mobileTitleSmallSb.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: const BackButton(color: Colors.white),
        actions: [
          //* Action: Open in Browser/External App.
          IconButton(
            tooltip: 'Open in external app',
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            onPressed: () => _launchExternal(LaunchMode.externalApplication),
          ),
          //* Action: Trigger platform-level download.
          IconButton(
            tooltip: 'Download file',
            icon: const Icon(
              Icons.download_for_offline_rounded,
              color: Colors.white,
            ),
            onPressed: () => _launchExternal(LaunchMode.platformDefault),
          ),
        ],
      ),
      body: Stack(
        children: [
          //* Main Viewer Layer.
          WebViewWidget(controller: _controller),

          //* Loading Layer: Overlayed until the WebView signals completion.
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
