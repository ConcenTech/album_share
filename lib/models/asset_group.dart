import '../core/utils/db_utils.dart';

class AssetGroup {
  AssetGroup(this.monthYearGroup, this.assetIds)
      : isarIds = assetIds.map((e) => fastHash(e)).toList();

  final String monthYearGroup;

  /// A list of all assets in this group.
  final List<String> assetIds;

  final List<int> isarIds;

  /// Expected number of assets in this group.
  /// 
  /// Actual number may be smaller if asset ids are missing from the db.
  int get length => assetIds.length;
}
