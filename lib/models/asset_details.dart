class AssetDetails {
  const AssetDetails(this.totalCount, this.monthYearGroups);
  /// The total number of assets across all albums.
  final int totalCount;
  /// Assets are grouped by their month and year in the library UI.
  final List<String> monthYearGroups;

  int get sectionCount => monthYearGroups.length;

}