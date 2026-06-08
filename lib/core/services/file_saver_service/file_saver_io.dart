import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Saves [bytes] to the device's Downloads folder (or Documents as fallback).
/// Returns the absolute path of the saved file.
Future<void> saveFile(Uint8List bytes, String filename) async {
  File? file;

  try {
    if (Platform.isAndroid) {
      // Try to write to public Android Downloads folder first
      final publicDownloads = Directory('/storage/emulated/0/Download');
      if (await publicDownloads.exists()) {
        file = File('${publicDownloads.path}/$filename');
      }
    }
  } catch (_) {
    // Ignore and fallback
  }

  // Fallback to path_provider directories (often app-specific / hidden from user)
  if (file == null) {
    final dir =
        await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    file = File('${dir.path}/$filename');
  }

  await file.writeAsBytes(bytes, flush: true);
}
