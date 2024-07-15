class AssetViewerScreenState {
  const AssetViewerScreenState({
    this.initialIndex = 0,
    this.heroOffset = 0,
    this.showStack = false,
  });

  final int initialIndex;
  final int heroOffset;
  final bool showStack;

  factory AssetViewerScreenState.fromQuery(Map<String, String> params) {
    return AssetViewerScreenState(
      initialIndex: int.parse(params['initialIndex'] ?? '0'),
      heroOffset: int.parse(params['heroOffset'] ?? '0'),
      showStack: bool.parse(params['showStack'] ?? 'false'),
    );
  }

  Map<String, String> toQuery() => {
        'initialIndex': '$initialIndex',
        'heroOffset': '$heroOffset',
        'showStack': '$showStack',
      };
}
