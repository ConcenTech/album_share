import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activity.dart';
import '../../models/album.dart';
import '../../models/asset.dart';
import '../api/api_provider.dart';
import '../auth/auth_providers.dart';
import '../database/database_providers.dart';
import 'activity_upload_service.dart';

abstract class ActivityProviders {
  /// Listens to a stream of activity.
  ///
  /// Filters out any activity linked to the current user.
  static final notifications =
      StreamProvider.autoDispose<List<Activity>>((ref) {
    final db = ref.watch(DatabaseProviders.service);
    final user = ref.watch(AuthProviders.userStream).value;

    if (user == null) {
      return db.activityStream();
    }
    return db.activityStreamForUser(user);
  });

  static final assetInAlbum = StreamProvider.autoDispose
      .family<List<Activity>, ({Asset asset, Album album})>((ref, params) {
    final db = ref.watch(DatabaseProviders.service);
    return db.activityStream(params);
  });

  static final countAll = StreamProvider.autoDispose<int>((ref) {
    final db = ref.watch(DatabaseProviders.service);
    return db.activityCountStream();
  });

  static final countAsset =
      StreamProvider.autoDispose.family<int, Asset>((ref, asset) {
    final db = ref.watch(DatabaseProviders.service);
    return db.activityCountStream(asset);
  });

  static final uploadService = Provider.autoDispose((ref) {
    final db = ref.watch(DatabaseProviders.service);
    final api = ref.watch(ApiProviders.service);

    return ActivityUploadService(api, db);
  });
}
