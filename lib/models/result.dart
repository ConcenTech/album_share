import 'package:flutter/foundation.dart';

class Result<T> {
  const Result(this._data) : _error = null;
  const Result.error(this._error) : _data = null;

  final T? _data;

  final String? _error;

  VoidCallback when(
    Function(T data) data,
    Function(String e) error,
  ) {
    if (_error != null) {
      return error(_error);
    }
    return data(_data!);
  }
}


typedef FutureResult<T>  = Future<Result<T>>;