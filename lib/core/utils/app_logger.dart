import 'dart:developer';

class AppLogger {
  AppLogger._();

  static void info(String message) {
    log(message, name: "INFO");
  }

  static void warning(String message) {
    log(message, name: "WARNING");
  }

  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    log(
      message,
      name: "ERROR",
      error: error,
      stackTrace: stackTrace,
    );
  }
}