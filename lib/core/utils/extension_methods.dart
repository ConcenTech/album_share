import '../../models/album.dart';
import '../../models/asset.dart';

extension Time on int {
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
  Duration get weeks => Duration(days: this * 7);
}

extension ListExtensions<E> on Iterable<E> {
  List<T> listWhereType<T>() {
    return whereType<T>().toList();
  }

  List<E> listWhere(bool Function(E e) f) => where(f).toList();

  List<T> mapList<T>(T Function(E e) f) => map(f).toList();
}

extension AlbumListEquality on List<Album> {
  bool equals(List<Album> albums) {
    if (length != albums.length) {
      return false;
    }
    for (var album in this) {
      if (!albums.contains(album)) {
        return false;
      }
    }
    return true;
  }
}

extension AssetListSorter on List<Asset> {
  List<Asset> sorted() {
    return [...this]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void merge(List<Asset> assets) {
    if (isEmpty){
      addAll(assets);
      return;
    }
    final a = this;
    for (var asset in assets) {
      final ind = a.indexWhere((ass) => ass.id == asset.id);
      if (ind == -1) {
        a.add(asset);
      } else {
        a[ind] = a[ind].merge(asset);
      }
    }
  }

  List<Asset> merged(List<Asset> assets) {
    return [...this]..merge(assets);
  }
}
