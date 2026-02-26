import 'package:flutter/foundation.dart';

/// Simple logging utility; in production you can replace with a proper logger.
void logInfo(String message, [Object? detail]) {
  if (kDebugMode) {
    // ignore: avoid_print
    print('[GeoTask] $message${detail != null ? ' $detail' : ''}');
  }
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  if (kDebugMode) {
    // ignore: avoid_print
    print('[GeoTask ERROR] $message');
    if (error != null) print(error);
    if (stackTrace != null) print(stackTrace);
  }
}
