import '../../immich/asset_grid/asset_grid_data_structure.dart';

class AssetViewerScreenState {
  const AssetViewerScreenState({
    required this.renderList,
    this.initialIndex = 0,
    this.heroOffset = 0,
    this.showStack = false,
  });

  final RenderList renderList;
  final int initialIndex;
  final int heroOffset;
  final bool showStack;

  factory AssetViewerScreenState.fromExtra(Object extra) {
    assert(extra is Map<String, dynamic>);
    extra as Map<String, dynamic>;
    return AssetViewerScreenState(
      renderList: extra['renderList'] ?? RenderList([], null, []),
      initialIndex: extra['initialIndex'] ?? 0,
      heroOffset: extra['heroOffset'] ?? 0,
      showStack: extra['showStack'] ?? false,
    );
  }

  Map<String, dynamic> toExtra() => {
        'renderList': renderList,
        'initialIndex': initialIndex,
        'heroOffset': heroOffset,
        'showStack': showStack,
      };
}
