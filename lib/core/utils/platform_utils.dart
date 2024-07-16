import 'package:flutter/foundation.dart';

T forPlatform<T>({
  required T Function() desktop,
  required T Function() mobile,
}) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return mobile();
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return desktop();
  }
}
