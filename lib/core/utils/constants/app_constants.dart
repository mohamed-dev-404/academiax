import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  AppConstants._();

  //? Base URL
  static String get baseUrl {
    if (kIsWeb) {
      // For Web, localhost is usually fine
      return 'http://localhost:3000/api/v1/';
    } else if (Platform.isAndroid) {
      // Android Emulator needs the 10.0.2.2 alias
      return 'http://10.0.2.2:3000/api/v1/';
    } else {
      // iOS Simulator or macOS/Windows desktop
      return 'http://localhost:3000/api/v1/';
    }
  }

  static const int maxSizeUploadPic = 5 * 1024 * 1024;
  static const String googleDocUrl = 'https://docs.google.com/gview?embedded=true&url=';
  static const Duration s3SendTimeout = Duration(minutes: 20);
  static const Duration s3ReceiveTimeout =  Duration(minutes: 20);

}
