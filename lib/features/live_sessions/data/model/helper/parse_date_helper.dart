import 'package:intl/intl.dart';

/// Converts a string to DateTime, handling ISO 8601 and custom backend formats.
DateTime parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return DateTime.now();

  // 1. Try Standard ISO 8601
  var parsed = DateTime.tryParse(dateStr);
  if (parsed != null) return parsed.toLocal();

  // 2. Try Custom Backend Format (M/d/yyyy, h:mm:ss a)
  try {
    return DateFormat('M/d/yyyy, h:mm:ss a').parse(dateStr, true).toLocal();
  } catch (e) {
    return DateTime.now();
  }
}

/// Converts a [DateTime] into a strict UTC ISO 8601 string expected by the backend.
/// e.g. "2026-04-19T16:50:37.000Z"
/// This prevents timezone shift bugs (Local GMT+2 vs Server UTC).
String formatToUtcIso(DateTime date) {
  // .toUtc() handles the timezone shift correctly
  // .toIso8601String() natively appends the 'Z' denoting UTC
  return date.toUtc().toIso8601String();
}
