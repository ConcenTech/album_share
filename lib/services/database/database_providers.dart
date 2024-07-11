import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_service.dart';

abstract class DatabaseProviders {
  static final service = Provider((ref) => DatabaseService.instance);
}