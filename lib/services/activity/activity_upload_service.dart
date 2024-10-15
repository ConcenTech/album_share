import '../../models/activity.dart';
import '../api/api_service.dart';
import '../database/database_service.dart';

class ActivityUploadService {
  ActivityUploadService(this._api, this._db);

  final ApiService _api;
  final DatabaseService _db;

  Future<void> uploadComment(
    String albumId,
    String assetId,
    String comment,
  ) async {
    final activity = await _api.uploadActivity(
        albumId, assetId, ActivityType.comment, comment);

    await _db.addActivity(activity);
  }
}
