import 'package:isar_community/isar.dart';
import 'package:logging/logging.dart';

part 'log.g.dart';

@collection
class Log {
  final Id id;

  final String message;

  final String? details;

  /// The name of the log level.
  final String level;

  final DateTime createdAt;

  /// Name of the logger this record came from.
  final String name;

  final String? stackTrace;

  const Log({
    this.id = Isar.autoIncrement,
    required this.message,
    required this.details,
    required this.level,
    required this.createdAt,
    required this.name,
    required this.stackTrace,
  });

  factory Log.fromRecord(LogRecord record) {
    return Log(
      message: record.message,
      details: record.error?.toString(),
      level: record.level.name,
      createdAt: record.time,
      name: record.loggerName,
      stackTrace: record.stackTrace?.toString(),
    );
  }

  /// Creates a string in the format:
  ///
  /// createdAt | level | name | message | details stackTrace
  String format() {
    return '$createdAt | '
        '${level.padRight(8)} | '
        '${name.padRight(20)} | '
        '$message ${details != null || stackTrace != null ? '|' : ''} '
        '${details ?? ''}'
        '${stackTrace ?? ''}';
  }
}
