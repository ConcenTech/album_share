import 'package:isar/isar.dart';

class Notification {
  const Notification({
    required this.name,
    required this.timestamp,
    required this.message,
    required this.assets,
    this.id = Isar.autoIncrement,
  });

  final Id id;
  final String name;
  final DateTime timestamp;
  final String message;
  final List<String> assets;

  Notification merge(Notification notification) {
    return Notification(
      name: name,
      timestamp: timestamp,
      message: message,
      assets: assets,
    );
  }
}
