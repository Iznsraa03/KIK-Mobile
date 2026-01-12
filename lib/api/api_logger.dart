import 'package:flutter/foundation.dart';

/// Simple debug-only logger for API layer.
///
/// In release/profile this will be silent.
class ApiLogger {
  const ApiLogger();

  static const ApiLogger instance = ApiLogger();

  void log(String message) {
    if (kDebugMode) {
      // debugPrint throttles long logs and avoids dropping on Android.
      debugPrint('[API] $message');
    }
  }
}
