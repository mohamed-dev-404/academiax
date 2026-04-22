import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/constants/app_constants.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/presentation/view/material_details/logic/material_details_handler.dart'; //_ Import Handler
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
    _initializeWebView(); //_ Extracted for cleanliness
  }

  //_ Logic extraction for WebView setup.
  void _initializeWebView() {
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
            onPressed: () => MaterialDetailsHandler.launchExternalUrl(
              context,
              widget.url,
              mode: LaunchMode.externalApplication,
            ),
          ),
          //* Action: Trigger platform-level download.
          IconButton(
            tooltip: 'Download file',
            icon: const Icon(
              Icons.download_for_offline_rounded,
              color: Colors.white,
            ),
            onPressed: () => MaterialDetailsHandler.launchExternalUrl(
              context,
              widget.url,
              mode: LaunchMode.platformDefault,
            ),
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
