import 'package:flutter/services.dart';

void hideStatusBar() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}

/// usage:
/// in main -> hideStatusBar();
