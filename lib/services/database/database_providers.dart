import 'package:album_share/models/album.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/asset.dart';
import 'database_service.dart';

abstract class DatabaseProviders {
  static final service = Provider((ref) => DatabaseService.instance);

  static final asset =
      FutureProvider.autoDispose.family<Asset?, String>((ref, String id) {
    return ref.watch(service).asset(id: id);
  });

  static final albums = FutureProvider.autoDispose
      .family<List<Album>, List<String>>((ref, albumIds) {
    return ref.watch(service).albums(albumIds);
  });
}
