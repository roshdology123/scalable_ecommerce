import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class AppLogger {
  static AppLogger? _instance;
  late Logger _logger;
  late String _logFilePath;
  bool _isInitialized = false;

  AppLogger._internal();

  factory AppLogger() {
    _instance ??= AppLogger._internal();
    return _instance!;
  }

  /// Initialize the logger with configuration
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Setup log file path
      await _setupLogFile();

      // Configure logger based on build mode
      _logger = Logger(
        filter: _CustomLogFilter(),
        printer: _getLogPrinter(),
        output: _getLogOutput(),
        level: _getLogLevel(),
      );

      _isInitialized = true;
      i('AppLogger initialized successfully');
    } catch (error) {
      // Fallback to simple console logging
      _logger = Logger(
        printer: SimplePrinter(),
        level: Level.info,
      );
      _isInitialized = true;
      e('Failed to initialize AppLogger: $error');
    }
  }

  /// Setup log file path for file logging
  Future<void> _setupLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      _logFilePath = '${logDir.path}/app_log_$dateStr.txt';
    } catch (e) {
      _logFilePath = '';
      if (kDebugMode) {
        print('Failed to setup log file: $e');
      }
    }
  }

  /// Get appropriate log printer based on environment
  LogPrinter _getLogPrinter() {
    if (kDebugMode) {
      return PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        excludeBox: const {},
        noBoxingByDefault: false,
      );
    } else {
      return ProductionPrinter();
    }
  }

  /// Get appropriate log output based on environment
  LogOutput _getLogOutput() {
    if (kDebugMode) {
      return MultiOutput([
        ConsoleOutput(),
        if (_logFilePath.isNotEmpty) FileOutput(file: File(_logFilePath)),
      ]);
    } else {
      // In production, only log to file
      return _logFilePath.isNotEmpty
          ? FileOutput(file: File(_logFilePath))
          : ConsoleOutput();
    }
  }

  /// Get appropriate log level based on environment
  Level _getLogLevel() {
    if (kDebugMode) {
      return Level.debug;
    } else if (kProfileMode) {
      return Level.info;
    } else {
      return Level.warning;
    }
  }

  /// Debug log
  void d(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.d(message, error: error, stackTrace: stackTrace);
    _logToDevTools('DEBUG', message, error, stackTrace);
  }

  /// Info log
  void i(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.i(message, error: error, stackTrace: stackTrace);
    _logToDevTools('INFO', message, error, stackTrace);
  }

  /// Warning log
  void w(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.w(message, error: error, stackTrace: stackTrace);
    _logToDevTools('WARNING', message, error, stackTrace);
  }

  /// Error log
  void e(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.e(message, error: error, stackTrace: stackTrace);
    _logToDevTools('ERROR', message, error, stackTrace);
  }

  /// Fatal/Critical log
  void f(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _ensureInitialized();
    _logger.f(message, error: error, stackTrace: stackTrace);
    _logToDevTools('FATAL', message, error, stackTrace);
  }

  /// Verbose log (only in debug mode)
  void v(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _ensureInitialized();
      _logger.t(message, error: error, stackTrace: stackTrace);
      _logToDevTools('VERBOSE', message, error, stackTrace);
    }
  }

  /// Network request log
  void logNetworkRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
    int? statusCode,
    String? responseBody,
    Duration? duration,
  }) {
    final message = '''
🌐 NETWORK REQUEST
Method: $method
URL: $url
Headers: ${headers ?? 'None'}
Body: ${body ?? 'None'}
Status: ${statusCode ?? 'Pending'}
Duration: ${duration?.inMilliseconds ?? '?'}ms
Response: ${responseBody ?? 'None'}
''';

    if (statusCode != null && statusCode >= 400) {
      w(message);
    } else {
      d(message);
    }
  }

  /// User action log
  void logUserAction(String action, [Map<String, dynamic>? data]) {
    final message = '''
👤 USER ACTION
Action: $action
Data: ${data ?? 'None'}
Timestamp: ${DateTime.now().toIso8601String()}
User: roshdology123
''';
    i(message);
  }

  /// Business logic log
  void logBusinessLogic(String operation, String result, [Map<String, dynamic>? context]) {
    final message = '''
💼 BUSINESS LOGIC
Operation: $operation
Result: $result
Context: ${context ?? 'None'}
''';
    i(message);
  }

  /// Performance log
  void logPerformance(String operation, Duration duration, [Map<String, dynamic>? metrics]) {
    final message = '''
⚡ PERFORMANCE
Operation: $operation
Duration: ${duration.inMilliseconds}ms
Metrics: ${metrics ?? 'None'}
''';

    if (duration.inMilliseconds > 1000) {
      w(message);
    } else {
      d(message);
    }
  }

  /// Cache operation log
  void logCacheOperation(String operation, String key, bool success, [String? details]) {
    final message = '''
💾 CACHE OPERATION
Operation: $operation
Key: $key
Success: $success
Details: ${details ?? 'None'}
''';
    d(message);
  }

  /// Authentication log
  void logAuth(String operation, bool success, [String? details]) {
    final message = '''
🔐 AUTHENTICATION
Operation: $operation
Success: $success
User: roshdology123
Details: ${details ?? 'None'}
Timestamp: ${DateTime.now().toIso8601String()}
''';

    if (success) {
      i(message);
    } else {
      w(message);
    }
  }

  /// State change log
  void logStateChange(String stateName, String from, String to, [Map<String, dynamic>? data]) {
    final message = '''
🔄 STATE CHANGE
State: $stateName
From: $from
To: $to
Data: ${data ?? 'None'}
''';
    d(message);
  }

  /// Error with context log
  void logErrorWithContext(
      String context,
      Object error,
      StackTrace stackTrace, [
        Map<String, dynamic>? additionalData,
      ]) {
    final message = '''
❌ ERROR WITH CONTEXT
Context: $context
Error: $error
Additional Data: ${additionalData ?? 'None'}
User: roshdology123
Timestamp: ${DateTime.now().toIso8601String()}
''';
    e(message, error, stackTrace);
  }

  /// Log to Flutter DevTools
  void _logToDevTools(String level, dynamic message, Object? error, StackTrace? stackTrace) {
    if (kDebugMode) {
      developer.log(
        message.toString(),
        name: 'ECommerceApp',
        level: _getLevelValue(level),
        error: error,
        stackTrace: stackTrace,
        time: DateTime.now(),
      );
    }
  }

  int _getLevelValue(String level) {
    switch (level) {
      case 'DEBUG':
      case 'VERBOSE':
        return 500;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
      case 'FATAL':
        return 1000;
      default:
        return 800;
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      // Fallback initialization
      _logger = Logger(
        printer: kDebugMode ? PrettyPrinter() : SimplePrinter(),
        level: kDebugMode ? Level.debug : Level.warning,
      );
      _isInitialized = true;
    }
  }

  /// Get log file path
  String get logFilePath => _logFilePath;

  /// Check if logger is initialized
  bool get isInitialized => _isInitialized;

  /// Clear old log files (keep last 7 days)
  Future<void> clearOldLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (await logDir.exists()) {
        final files = await logDir.list().toList();
        final now = DateTime.now();

        for (final file in files) {
          if (file is File && file.path.contains('app_log_')) {
            final stats = await file.stat();
            final daysDiff = now.difference(stats.modified).inDays;

            if (daysDiff > 7) {
              await file.delete();
              d('Deleted old log file: ${file.path}');
            }
          }
        }
      }
    } catch (error) {
      e('Failed to clear old logs: $error');
    }
  }

  /// Get log file content (for debugging or support)
  Future<String?> getLogFileContent() async {
    try {
      if (_logFilePath.isNotEmpty) {
        final file = File(_logFilePath);
        if (await file.exists()) {
          return await file.readAsString();
        }
      }
      return null;
    } catch (e) {
      w('Failed to read log file: $e');
      return null;
    }
  }
}

/// Custom log filter
class _CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In debug mode, log everything
    if (kDebugMode) return true;

    // In release mode, only log warnings and errors
    return event.level.index >= Level.warning.index;
  }
}

/// Production printer for release builds
class ProductionPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final timestamp = DateTime.now().toIso8601String();
    final level = event.level.name.toUpperCase();
    final message = event.message;

    return ['[$timestamp] [$level] $message'];
  }
}