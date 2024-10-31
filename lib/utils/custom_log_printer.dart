import 'dart:developer';

/// A utility class for consistent logging throughout the app.
///
/// Provides methods for logging messages and debug information with error details.
/// Uses dart:developer [log] for output and handles logging failures gracefully.
///
/// The class follows a singleton pattern with a static [instance] for global access.
///
/// Example usage:
/// ```dart
/// // Basic logging
/// CustomLogPrinter.instance.printLog("User action completed");
///
/// // Debug logging with error details
/// try {
///   // Some code that may throw
/// } catch (e, stackTrace) {
///   CustomLogPrinter.instance.printDebugLog(
///     "Operation failed",
///     e,
///     stackTrace
///   );
/// }
/// ```
class CustomLogPrinter {
  /// Singleton instance of the CustomLogPrinter class.
  /// Used to access logging functionality throughout the app.
  static CustomLogPrinter instance = CustomLogPrinter();

  /// Logs a message to the debug console.
  ///
  /// Takes a [val] string parameter containing the message to log.
  /// Uses dart:developer [log] for output.
  ///
  /// If logging fails, catches the exception and logs an error message.
  ///
  /// Example:
  /// ```dart
  /// CustomLogPrinter.instance.printLog("User logged in successfully");
  /// ```
  void printLog(String val) {
    try {
      log(val);
    } catch (e) {
      log("printDebugLog Exception ==>$e");
    }
  }

  /// Logs a debug message with error details and stack trace.
  ///
  /// Takes three parameters:
  /// - [val] - The message to log and use as the log name
  /// - [er] - The error object to include in the log
  /// - [st] - The stack trace associated with the error
  ///
  /// Uses dart:developer [log] to output the message with error details.
  /// If logging fails, catches the exception and logs an error message.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   // Some code that may throw
  /// } catch (e, stackTrace) {
  ///   CustomLogPrinter.instance.printDebugLog(
  ///     "Error occurred",
  ///     e,
  ///     stackTrace
  ///   );
  /// }
  /// ```
  printDebugLog(String val, Object er, StackTrace st) {
    try {
      log(val, name: val, error: er, stackTrace: st);
    } catch (e) {
      log("printDebugLog Exception ==>$e");
    }
  }
}
