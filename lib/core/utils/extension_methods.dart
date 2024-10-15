import 'dart:core';

import '../../models/album.dart';

extension StringDuration on String {
  Duration? toDuration() {
    try {
      final parts = split(':')
          .map((e) => double.parse(e).toInt())
          .toList(growable: false);
      return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
    } catch (e) {
      return null;
    }
  }
}

extension IntExtensions on int {
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
  Duration get weeks => Duration(days: this * 7);
}

extension DoubleExtensions on double {
  double difference(double other) {
    return this - other;
  }
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
