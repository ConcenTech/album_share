extension Time on int {
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
  Duration get weeks => Duration(days: this *7);
}

extension ListExtensions<E> on Iterable<E> {
  List<T> listWhereType<T>() {
    return whereType<T>().toList();
  }

  List<E> listWhere(bool Function(E e) f) => where(f).toList();

 List<T> mapList<T>(T Function(E e) f) => map(f).toList();
}