import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';
import '../database/database_providers.dart';

final appInitProvider = FutureProvider((ref) async {
    // Ensure cookies are retrieved from storage.
  await ref.watch(ApiProviders.cookies.future);

  final database = ref.watch(DatabaseProviders.service);
  await database.init();

});