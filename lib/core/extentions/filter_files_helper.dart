import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

/// [FileHelper] extension on [String]
/// This helper manages file type detection, UI icons, and brand colors based on file extensions.

//!! extract file type from file name for Upload file
extension FileHelper on String {
  String get fileContentType {
    // lookupMimeType(this) will return strings like 'application/pdf', 'video/mp4', etc.
    return lookupMimeType(this) ?? 'application/octet-stream';
  }

  // --- 1. File Type Detection (Checking if the file is a video) ---
  /// Returns [true] if the string (file name) ends with common video extensions.
  bool get isVideo {
    // List of video formats based on your FileContentType Enum
    final videoExtensions = ['mp4', 'mkv', 'mov', 'avi', 'webm', 'ogg'];
    return videoExtensions.any((ext) => toLowerCase().endsWith('.$ext'));
  }

  // --- 2. Dynamic Icon Logic ---
  /// Maps the file extension to a specific [IconData] for the UI.
  IconData get fileIcon {
    final name = toLowerCase();

    if (isVideo) return Icons.play_circle_fill; // Videos
    if (name.endsWith('.pdf')) return Icons.picture_as_pdf; // PDF Documents

    // Presentation files (PowerPoint)
    if (name.endsWith('.pptx') || name.endsWith('.ppt')) return Icons.slideshow;

    // Word Documents
    if (name.endsWith('.docx') || name.endsWith('.doc'))
      {return Icons.description;}

    // Spreadsheets (Excel / CSV)
    if (name.endsWith('.xlsx') ||
        name.endsWith('.xls') ||
        name.endsWith('.csv')) {
      return Icons.table_chart;
    }

    // Images
    if (name.endsWith('.jpg') ||
        name.endsWith('.png') ||
        name.endsWith('.webp')) {
      return Icons.image;
    }

    // Default fallback icon
    return Icons.insert_drive_file;
  }

  // --- 3. Brand Color Logic ---
  /// Returns a specific [Color] according to the file type for consistent branding.
  Color get fileColor {
    final name = toLowerCase();

    if (isVideo) return AppColors.secondary; // Video: Blue
    if (name.endsWith('.pdf')) return Colors.red; // PDF: Red

    // PPT: Orange
    if (name.endsWith('.pptx') || name.endsWith('.ppt')) return Colors.orange;

    // Word: Blue Accent
    if (name.endsWith('.docx') || name.endsWith('.doc'))
      {return Colors.blueAccent;}

    // Excel: Green
    if (name.endsWith('.xlsx') || name.endsWith('.xls')) return Colors.green;

    // Images: Purple/Indigo
    if (name.endsWith('.jpg') || name.endsWith('.png')) return Colors.indigo;

    // Default: Grey for unknown types
    return Colors.grey;
  }
}
