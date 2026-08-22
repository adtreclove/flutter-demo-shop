import 'package:flutter/foundation.dart';

/// ANSI color codes you can pass to [logD].
enum LogColor {
  red('\x1B[31m'),
  green('\x1B[32m'),
  yellow('\x1B[33m'),
  blue('\x1B[34m'),
  magenta('\x1B[35m'),
  cyan('\x1B[36m'),
  white('\x1B[37m'),
  gray('\x1B[90m');

  final String code;
  const LogColor(this.code);
}

const String _reset = '\x1B[0m';

/// Prints [message] to the console only in debug mode, in the given [color].
///
/// Usage:
///   logD('User logged in', color: LogColor.green);
///   logD('Something went wrong', color: LogColor.red);
void coloredLog(
  Object? message, {
  LogColor color = LogColor.white,
  String? tag,
}) {
  if (!kDebugMode) return;

  final prefix = tag != null ? '[$tag] ' : '';
  // Using debugPrint avoids truncation issues with long strings on Android.
  debugPrint('${color.code}$prefix$message$_reset');
}
