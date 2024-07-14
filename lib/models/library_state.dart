import 'asset.dart';

abstract class LibraryState {
  const LibraryState();
  factory LibraryState.building() => _BuildingLibraryState();
  factory LibraryState.built(List<Asset> assets) => _BuiltLibraryState(assets);

  bool get isBuilding => this is _BuildingLibraryState;

  List<Asset> get assets => throw UnimplementedError('Unable to list assets when library is building');

  T when<T>({
    required T Function() building,
    required T Function(List<Asset> assets) built,
  }) {
    switch (this) {
      case final _BuildingLibraryState _:
        return building();
      case final _BuiltLibraryState state:
        return built(state._assets);
    }
    throw UnimplementedError();
  }
}

class _BuildingLibraryState extends LibraryState {}

class _BuiltLibraryState extends LibraryState {
  const _BuiltLibraryState(this._assets);
  final List<Asset> _assets;

  @override
  List<Asset> get assets =>_assets;
}