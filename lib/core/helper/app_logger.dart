import 'package:logger/logger.dart';

/// class for logging messages with different severity levels
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 70,
      colors: true,
      printEmojis: true,
    ),
  );

  static bool _enabled = true;

  /// enable or disable logging
  static void setEnabled(bool value) {
    _enabled = value;
  }

  /// log a general message with optional error and stack trace
  static void log(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] $message' : message;
    if (error != null) {
      _logger.e(logMessage, error: error, stackTrace: stackTrace);
    } else {
      _logger.i(logMessage);
    }
  }

  /// log a debug message with optional tag
  static void debug(dynamic message, {String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] $message' : message;
    _logger.d(logMessage);
  }

  /// log an info message with optional tag
  static void info(dynamic message, {String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] $message' : message;
    _logger.i(logMessage);
  }

  /// log a warning message with optional error, stack trace, and tag
  static void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] ⚠️ $message' : '⚠️ $message';
    _logger.w(logMessage, error: error, stackTrace: stackTrace);
  }

  /// log an error message with optional error, stack trace, and tag
  static void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] ❌ $message' : '❌ $message';
    _logger.e(logMessage, error: error, stackTrace: stackTrace);
  }

  /// log a success message with optional tag
  static void success(String message, {String? tag}) {
    if (!_enabled) return;
    final logMessage = tag != null ? '[$tag] ✅ $message' : '✅ $message';
    _logger.i(logMessage);
  }
}
